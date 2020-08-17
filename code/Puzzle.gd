extends Node2D

var width = 4
var height = 5
var blocks = []
var block_scene = load("res://Block.tscn")
var block_chooser = null;
const NUM_SETUP_BLOCKS = 20;
var setup_blocks = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	# Green vertical column.
#	add_block(0,0)
#	add_block(0,1)
#	add_block(0,2)
#	add_block(0,3)
#
#	# Blue-violet vertical column.
#	add_block(1,0, Color.blueviolet)
#	add_block(1,1, Color.blueviolet)
#	add_block(1,2, Color.blueviolet)
#
#	# Green horizontal row.
#	add_block(2,0)
#	add_block(3,0)
#	add_block(4,0)
#
#	# Blue-violet horizontal row.
#	add_block(3,2)
#	add_block(4,2)
	
	$TickTimer.start()

func setup_puzzle(number_of_blocks=20):
	for i in range(number_of_blocks):
		var random_block = add_random_block()
		drop_block(random_block)

func init(x, y):
	width = x
	height = y
	
#	for i in range(x):
#		var row = []
#		for j in range(y):
#			row.append(0)
#		grid.append(row)

func grid_position_to_pixel(x, y):
	return Vector2((x * 128) + 64, (x * 128) + 64)
	
func pixel_to_grid_position(x_pixel, y_pixel):
	return Vector2((x_pixel - 64) / 128, (y_pixel - 64) / 128)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_random_block():
	randomize()
	
	return add_block(randi() % (width+1), 0, 'random')

func is_position_occupied(x, y):
	for block in blocks:
		var pixel_position = grid_position_to_pixel(x, y)
		if block.global_position == pixel_position:
			return true
			
	return false

func add_block(x, y, color=Color.greenyellow):
	# At position (0,0), block should be drawn at pixel (64,64)
	if is_position_occupied(x, y):
		print('position ', Vector2(x,y), ' is occupied. Cannot add block.')
		return
		
	var block = block_scene.instance()
	
	block.global_position.x = (x * 128) + 64
	block.global_position.y = (y * 128) + 64
	add_child(block)
	block.set_color(color)
	
	blocks.append(block)
	
	return block

func can_block_move(block, pixel_difference=128):
	for other_block in blocks:
		if block == other_block:
			continue
		
		# If there's another block directly below, then the block can't move.
		if block.global_position.y + pixel_difference == other_block.global_position.y and block.global_position.x == other_block.global_position.x:
			block.hit_bottom(true)
			return false
			
	# If the block reaches the bottom, then the block can't move.
	var block_grid_position = pixel_to_grid_position(block.global_position.x, block.global_position.y)
	if block_grid_position.y >= height:
		block.hit_bottom(true)
		return false

	return true
	
func sort_blocks(blocks):
	blocks.sort_custom(self, 'block_sort_comparison')

func block_sort_comparison(block_a, block_b):
	return block_a.global_position.y > block_b.global_position.y

func move_block(block, pixel_difference=128):
	block.global_position.y += pixel_difference
	
func drop_block(block, pixel_difference=128):
	while can_block_move(block):
		block.global_position.y += pixel_difference
	
func delete_block(block):
	blocks.remove(blocks.find(block))
	block.delete()
	
func block_colors_match(block1, block2):
	return block1.get_node('Sprite').modulate == block2.get_node('Sprite').modulate
	
func get_block_at_position(x, y):
	for block in blocks:
		if block.global_position.x == x and block.global_position.y == y:
			return block
	
	return null

func blocks_are_continuously_adjacent(direction, block1, block2, pixel_difference=128):
	if not direction in ['vertical', 'horizontal']:
		push_error(direction + ' is not a known direction. Erroring.')
	
	if direction == 'vertical':
		if block1.global_position.y > block2.global_position.y:
			push_error("block 1's y position is greater than block 2's y position. Please reverse this. Erroring.")
		else:
			for y in range(block1.global_position.y + pixel_difference, block2.global_position.y, pixel_difference):
				var block_underneath = get_block_at_position(block1.global_position.x, y)
				if block_underneath == null or block_underneath.has_hit_bottom:
					return false
					
				if not block_colors_match(block1, block_underneath):
					return false
					
	elif direction == 'horizontal':
		if block1.global_position.x > block2.global_position.x:
			push_error("block 1's X position is greater than block 2's X position. Please reverse this. Erroring.")
		else:
			for x in range(block1.global_position.x + pixel_difference, block2.global_position.x, pixel_difference):
				var block_to_the_right = get_block_at_position(x, block1.global_position.y)
				if block_to_the_right == null or block_to_the_right.has_hit_bottom:
					return false
					
				if not block_colors_match(block1, block_to_the_right):
					return false
	
	return true
	

func get_adjacent_horizontal_blocks(block):
	var adjacent_blocks = []
	for other_block in blocks:
		if block == other_block or other_block.has_hit_bottom == false or block_colors_match(block, other_block) == false:
			continue
		
		# If the other block is on the same row as block.
		if block.global_position.y == other_block.global_position.y:
			# If the other block is touching the block.
			if block.is_touching(other_block):
				adjacent_blocks.append(other_block)
			# If the other block is continously adjacent with block.
			else:
				if block.global_position.x < other_block.global_position.x:
					if blocks_are_continuously_adjacent('horizontal', block, other_block):
						adjacent_blocks.append(other_block)
				else:
					if blocks_are_continuously_adjacent('horizontal', other_block, block):
						adjacent_blocks.append(other_block)
	
	return adjacent_blocks
	
func get_adjacent_vertical_blocks(block):
	var adjacent_blocks = []
	for other_block in blocks:
		if block == other_block or other_block.has_hit_bottom == false or block_colors_match(block, other_block) == false:
			continue
		
		# If the other block is on the same column as block.
		if block.global_position.x == other_block.global_position.x:
			# If the other block is touching the block.
			if block.is_touching(other_block):
				adjacent_blocks.append(other_block)
			# If the other block is continously adjacent with block.
			else:
				if block.global_position.y < other_block.global_position.y:
					if blocks_are_continuously_adjacent('vertical', block, other_block):
						adjacent_blocks.append(other_block)
				else:
					if blocks_are_continuously_adjacent('vertical', other_block, block):
						adjacent_blocks.append(other_block)
	
	return adjacent_blocks

	
func get_surrounding_blocks(block, pixel_difference=128):
	var surrounding_blocks = []
	for other_block in blocks:
		if not block_colors_match(block, other_block) or other_block == block:
			continue
			
		if not block.is_touching(other_block) and not block.is_diagonal(other_block):
			continue
			
		# if other block is on top
		if other_block.global_position.y < block.global_position.y:
			if  other_block.global_position.x == block.global_position.x:
				surrounding_blocks.append(other_block)
		# if other_block is on right of block
		elif other_block.global_position.y == block.global_position.y and other_block.global_position.x > block.global_position.x:
			surrounding_blocks.append(other_block)
		# if other block is below
		elif other_block.global_position.y > block.global_position.y:
			if other_block.global_position.x == block.global_position.x:
				surrounding_blocks.append(other_block)
		# if other_block is left of block
		elif other_block.global_position.y == block.global_position.y and other_block.global_position.x < block.global_position.x:
			surrounding_blocks.append(other_block)
	return surrounding_blocks
			
func extend_but_ignore_duplicates(original_list, appended_list):
	var new_list = [] + original_list
	for appended_element in appended_list:
		if not appended_element in original_list:
			new_list.append(appended_element)
	
	return new_list

func find_matches():
	# Match scenarios:
	# Any number (greater than 2) of blocks of matching types on the same row and touching.
	# Any number (greater than 2) of blocks of matching types on the same column and touching.
	# 2 or more blocks surrounding (diagonal included) a block.
	
	var matching_blocks = []
	for block in blocks:
		if not block.has_hit_bottom:
			continue
			
		var adjacent_horizontal_blocks = get_adjacent_horizontal_blocks(block)
		if adjacent_horizontal_blocks.size() >= 2:
			matching_blocks = extend_but_ignore_duplicates(matching_blocks, [block])
			matching_blocks = extend_but_ignore_duplicates(matching_blocks, adjacent_horizontal_blocks)
		
		var adjacent_vertical_blocks = get_adjacent_vertical_blocks(block)
		if adjacent_vertical_blocks.size() >= 2:
			matching_blocks = extend_but_ignore_duplicates(matching_blocks, [block])
			matching_blocks = extend_but_ignore_duplicates(matching_blocks, adjacent_vertical_blocks)
		
		var surrounding_blocks = get_surrounding_blocks(block)
		if surrounding_blocks.size() >= 3:
			matching_blocks = extend_but_ignore_duplicates(matching_blocks, [block])
			matching_blocks = extend_but_ignore_duplicates(matching_blocks, surrounding_blocks)
			
	for matching_block in matching_blocks:
		delete_block(matching_block)
		

func print_block_names():
	print('#### block names ####')
	for block in blocks:
		print(block.name)
	print('####             ####')

func _on_TickTimer_timeout():
	

	find_matches()

func _on_DropTimer_timeout():
	sort_blocks(blocks)
	
	for block in blocks:
		if can_block_move(block):
			drop_block(block)

	add_random_block()
