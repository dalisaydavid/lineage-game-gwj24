extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func float_up():
	$FloatUpTween.interpolate_property(
		self, 
		'position',
		self.global_position, 
		Vector2(self.global_position.x, self.global_position.y-20), 
		3,
		Tween.TRANS_QUART, 
		Tween.EASE_OUT
	)
	$FloatUpTween.start()

func _on_LiveTimer_timeout():
	queue_free()
