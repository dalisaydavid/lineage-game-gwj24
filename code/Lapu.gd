extends Node2D


var dialog = [
	"I am Lapu, leader of this country's revolution.",
	"This is our land and I refuse to give up to the invaders!",
	"Attack!"
]
var dialog_index = 0

func _ready():
	set_process_input(true)
	unshine()

func _input(event):
	if event.is_action_released("choose"):
		update_story_label()
		
		if dialog_index == dialog.size():
			get_node('Puzzle').start()
			$"/root/AudioPlayer".play("res://music/lapu.wav", false)
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



func _on_TextureButton_pressed():
	get_tree().change_scene("res://Riza.tscn")


func _on_Timer_timeout():
	$Puzzle.add_row_of_blocks(5)
	$Alert.visible = false
