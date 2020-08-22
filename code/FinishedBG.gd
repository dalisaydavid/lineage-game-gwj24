extends Node2D


onready var done = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event.is_action_released("restart_scene"):
		get_tree().reload_current_scene()


func appear(end_game_status):
	$TimerBeforeContinueOption.start()
	var tween = get_node("AppearTween")
	
	var sprite = null
	if end_game_status == 1:
		sprite = get_node('Sprite')
		$Position2D/Label.set_text('Win!')
		$Position2D/Label.set_visible(true)
	else:
		sprite = get_node('SpriteLose')
		$Position2D/Label.set_text('Lose.')
		$Position2D/Label.set_visible(true)
		$Position2D/Label2.set_visible(true)
	
	tween.interpolate_property(
		sprite,
		'modulate',
		Color(sprite.modulate.r, sprite.modulate.g, sprite.modulate.b, 0), 
		Color(sprite.modulate.r, sprite.modulate.g, sprite.modulate.b, 1), 
		2,
		Tween.TRANS_QUART, 
		Tween.EASE_OUT
	)
	tween.start()
	


func _on_TimerBeforeContinueOption_timeout():
	done = true


func _on_AppearTween_tween_started(object, key):
	done = false
