extends Node2D

export(String, FILE, '*tscn') var next_scene_path

var dialog = [
	"Jano Cruz. The best gun slinger in the country...",
	"I've never lost a single duel, and I don't plan to.",
	"This here gang is trying to do me dirty, planning an attack from every angle.",
	"Short on ammo, but I plan to win.",
]
var dialog_index = 0

func _ready():
	set_process_input(true)
	unshine()
	$"/root/AudioPlayer".play("res://music/jano.wav", false)

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
		$Puzzle.explode_random_block()
	$Alert.visible = false
