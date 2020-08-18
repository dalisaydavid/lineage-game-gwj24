extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func shine():
	var tween = get_node("ShineTween")
	tween.interpolate_property(
		get_node('Light2D'), 
		'energy',
		0,
		3, 
		3,
		Tween.TRANS_QUART, 
		Tween.EASE_OUT
	)
	tween.start()


func _on_ShineTween_tween_all_completed():
	get_parent().get_node('NextButton').visible = true
