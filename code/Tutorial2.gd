extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event.is_action_released("restart_scene"):
		get_tree().change_scene("res://Tutorial.tscn")
	elif event.is_action_released("choose"):
		get_tree().change_scene("res://Lapu.tscn")
