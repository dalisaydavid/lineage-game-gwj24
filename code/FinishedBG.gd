extends Node2D


onready var done = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func appear(end_game_status):
	$TimerBeforeContinueOption.start()
	var tween = get_node("AppearTween")
	
	var sprite = null
	if end_game_status == 1:
		sprite = get_node('Sprite')
	else:
		sprite = get_node('SpriteLose')
	
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
	
	$Position2D.set_visible(true)


func _on_TimerBeforeContinueOption_timeout():
	done = true


func _on_AppearTween_tween_started(object, key):
	done = false
