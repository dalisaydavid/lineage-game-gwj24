extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func play(track):
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = load(track)
	$AudioStreamPlayer.volume_db = -80
	$AudioStreamPlayer.play()
	fade_in()

func fade_in():
	print("FADING IN")
	$VolumeInTween.interpolate_property($AudioStreamPlayer, "volume_db", -80, -10, 4, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN, 0)
	$VolumeInTween.start()



func _on_VolumeInTween_tween_all_completed():
	print("DONE FADING IN")
