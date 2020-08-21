extends Node2D

#var colors = [
#	Color.green,
#	Color.blue,
#	Color.red,
#	Color.orange,
#	Color.purple,
#	Color.white
#]

export var use_tutorial_color = false
# https://coolors.co/540d6e-ee4266-ffd23f-3bceac-0ead69
var colors = [
	Color('540d6e'),
	Color('ee4266'),
	Color('ffd23f'),
	Color('3bceac'),
	Color('0ead69')
]

const HIT_BOTTOM_COLOR = Color.darkred

var points_reward = 5
var has_hit_bottom = false
var is_highlighted = false
var is_zapped = false
var is_stone = false

func _ready():
	randomize()
	$Sprite.modulate = colors[randi() % colors.size()]
	
	if use_tutorial_color:
		$Sprite.modulate = Color('540d6e')

func get_color():
	return $Sprite.modulate
	
func set_color(color):
	if color == Color(-1,-1,-1,-1):
		randomize()
		$Sprite.modulate = colors[randi() % colors.size()]
	else:
		$Sprite.modulate = color
	
func hit_bottom(b):
	has_hit_bottom = b
	
func zap():
	is_zapped = true
	$ZapSprite.visible = true

func set_to_stone():
	is_stone = true
	$Sprite.modulate = Color.slategray

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func is_touching(other_block, pixel_difference=128):
	# if the y values are off by 1 position/128 pixels, but the x values are the same, then they're touching.
	if abs(self.global_position.y - other_block.global_position.y) == pixel_difference and self.global_position.x == other_block.global_position.x:
		return true
		
	# if the x values are off by 1 position/128 pixels, but the y values are the same, then they're touching.
	if abs(self.global_position.x - other_block.global_position.x) == pixel_difference and self.global_position.y == other_block.global_position.y:
		return true
		
	return false
	
func is_diagonal(other_block, pixel_difference=128):
	return abs(self.global_position.y  - other_block.global_position.y) == pixel_difference and abs(self.global_position.x - other_block.global_position.x) == pixel_difference

func delete():
	$Light2D.enabled = true
	var tween = get_node('DeleteTween')
	tween.interpolate_property(
		self, 
		'scale',
		Vector2(1, 1), 
		Vector2(1.15, 1.15), 
		0.45,
		Tween.TRANS_QUART, 
		Tween.EASE_OUT
	)
	tween.start()
	
	return points_reward

func _on_DeleteTween_tween_all_completed():
	queue_free()

func highlight(on):
	if on and not has_hit_bottom:
		$Sprite.modulate.a = 0.5
	else:
		$Sprite.modulate.a = 1.0

func _on_Area2D_area_exited(area):
	if area.is_in_group('chooser'):
		highlight(false)


func _on_Area2D_area_entered(area):
	if area.is_in_group('chooser'):
		highlight(true)
