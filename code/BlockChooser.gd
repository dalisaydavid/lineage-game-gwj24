extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_released('choose'):
		choose()
		
func choose(pixel_difference=128):
	var left_chooser_areas = $LeftChooser/Area2D.get_overlapping_areas()
	var right_chooser_areas = $RightChooser/Area2D.get_overlapping_areas()
	
	if left_chooser_areas.size() <= 0 and right_chooser_areas.size() <= 0:
		return
	
	if left_chooser_areas.size() > 0:
		var left_block = left_chooser_areas[0].get_parent()
		left_block.global_position.x += pixel_difference
	if right_chooser_areas.size() > 0:
		var right_block = right_chooser_areas[0].get_parent()
		right_block.global_position.x -= pixel_difference
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_global_mouse_position()
