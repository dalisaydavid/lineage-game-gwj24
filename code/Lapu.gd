extends Node2D


var dialog = [
	"I am Lapu, leader of this country's revolution.",
	"This is our land and I refuse to give up to the invaders!",
	"Attack!"
]
var dialog_index = 0

func _ready():
	set_process_input(true)
	update_story_label()

func _input(event):
	if event.is_action_released("choose"):
		update_story_label()
		
		if dialog_index == dialog.size():
			get_node('Puzzle').start()
			set_process_input(false)

func update_story_label():
	get_node('StoryUI').get_node('HBoxContainer').get_node('VBoxContainer').get_node('StoryContainer').get_node('VBoxContainer').get_node('StoryLabel').text = dialog[dialog_index]
	
	dialog_index += 1
