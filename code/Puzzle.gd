extends Node2D

var width = 4
var height = 5
var blocks = []
var block_scene = load("res://Block.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#add_block(0,0)
	#add_block(0,3)
	#add_block(1,1)
	#add_block(1,2)
	pass

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
	
	add_block(randi() % (width+1), 0)

func add_block(x, y):
	# At position (0,0), block should be drawn at pixel (64,64)
	
	var block = block_scene.instance()
	
	block.global_position.x = (x * 128) + 64
	block.global_position.y = (y * 128) + 64
	add_child(block)
	
	blocks.append(block)

func get_moving_blocks(blocks):
	var moving_blocks = []
	for block in blocks:
		if not block.has_hit_bottom:
			moving_blocks.append(block)
			
	return moving_blocks

func can_block_move(block, pixel_difference=128):
	sort_blocks_by_y(blocks)
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
	
func sort_blocks_by_y(blocks):
	blocks.sort_custom(self, 'block_sort_comparison')

func block_sort_comparison(block_a, block_b):
	return block_a.global_position.y > block_b.global_position.y

func move_block(block, pixel_difference=128):
	block.global_position.y += pixel_difference
	
func delete_block(block):
	blocks.remove(blocks.find(block))
	block.delete()

func find_matches():
	var matching_blocks = []
	for block in blocks:
		if not block.has_hit_bottom:
			continue
		
		for other_block in blocks:
			if block == other_block:
				continue
			
			if not block.is_touching(other_block):
				continue
				
			if not other_block.has_hit_bottom:
				continue
			
			if block.get_color() == other_block.get_color():
				if not block in matching_blocks:
					matching_blocks.append(block)
				if not other_block in matching_blocks:
					matching_blocks.append(other_block)
	
	for block in matching_blocks:
		delete_block(block)
		

func _on_TickTimer_timeout():
	
	for block in blocks:
		if can_block_move(block):
			move_block(block)

	find_matches()

	add_random_block()
