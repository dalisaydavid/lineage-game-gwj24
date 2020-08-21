extends Node2D

export(String, FILE, '*tscn') var next_scene_path

var dialog = [
	"I am Rubak, the smartest inventor of all time.",
	"This here technology is my best invention yet.",
	"Except it has a major bug: It tries to kill me.",
	"Prepare for your bugs to become features, robot!",
]
var dialog_index = 0

func _ready():
	set_process_input(true)
	unshine()
	$"/root/AudioPlayer".play("res://music/riza.wav", false)

func _input(event):
	if event.is_action_released("choose"):
		update_story_label()
		
		if dialog_index == dialog.size():
			set_process_input(false)
			$CountdownBG.start()

func start():
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
		5,
		Tween.TRANS_QUART, 
		Tween.EASE_OUT
	)
	tween.start()

func _on_Timer_timeout():
	if $Puzzle.start_puzzle:
		$Puzzle.add_random_stone_block()
	$Alert.visible = false
