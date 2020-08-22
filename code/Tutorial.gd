extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_tutorial_done = false
var animation_index = 0
const max_animations = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_process_input(true)
	play_next_animation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event.is_action_released("choose"):
		play_next_animation()
	elif event.is_action_released('restart_scene'):
		get_tree().reload_current_scene()

func play_next_animation():
	if animation_index >= max_animations:
		get_tree().change_scene("res://Tutorial2.tscn")
	else:
		$AnimationPlayer.play("Tutorial" + str(animation_index))
		animation_index += 1
