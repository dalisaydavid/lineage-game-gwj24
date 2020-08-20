extends Node2D


var dialog = [
	"I am Jano, the smartest inventor of all time.",
	"This here technology is my best invention yet.",
	"Except it has a major bug: It tries to kill me.",
	"Prepare to to become a feature, robot slave!",
]
var dialog_index = 0

func _ready():
	set_process_input(true)
	unshine()
	$"/root/AudioPlayer".play("res://music/lapu.wav", false, -20)

func _input(event):
	if event.is_action_released("choose"):
		update_story_label()
		
		if dialog_index == dialog.size():
			get_node('Puzzle').start()
			set_process_input(false)

func update_story_label():
	get_node('StoryUI').get_node('HBoxContainer').get_node('VBoxContainer').get_node('StoryContainer').get_node('VBoxContainer').get_node('StoryLabel').text = dialog[dialog_index]
	
	dialog_index += 1
	
func unshine():
	var tween = get_node("Light2D/UnshineTween")
	tween.interpolate_property(
		get_node('Light2D'), 
		'energy',
		3,
		0, 
		3,
		Tween.TRANS_QUART, 
		Tween.EASE_OUT
	)
	tween.start()


func _on_Timer_timeout():
	$Puzzle.explode_random_block()
	$Alert.visible = false
