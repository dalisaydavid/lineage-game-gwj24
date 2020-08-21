extends Node2D

export(String, FILE, '*tscn') var next_scene_path

var dialog = [
	"I am Riza, the author of 'The Great History'.",
	"My book is... quite controversial. But it speaks the truth of the history of our country.",
	"Other great authors tell me that I'm not good enough.",
	"I'll show them, I'll tell them my story!",
]
var dialog_index = 0

func _ready():
	set_process_input(true)
	unshine()
	$"/root/AudioPlayer".play("res://music/riza.wav", false, -40)

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
		5,
		Tween.TRANS_QUART, 
		Tween.EASE_OUT
	)
	tween.start()



func _on_Timer_timeout():
	$Puzzle.replace_blocks()
	$Alert.visible = false


func _on_TextureButton_pressed():
	get_tree().change_scene("res://Jano.tscn")
