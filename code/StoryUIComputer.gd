extends MarginContainer


var dialog = [
	"Okay... Shall we?",
	"What was it again? findmyfamily.com? Sounds like a virus.",
	"Alright let's see if I remember my name...",
	"I'll type findmyfamily.com/manny_cruz"
]

var next_dialog = [
	"Hm. Must be an issue.",
	"What do you mean no results?",
	"This is frustrating.",
	"I have no family members?"
]
var dialog_index = 0
var dialog_finished = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)

func _process(delta):
	if dialog_index == dialog.size() and not dialog_finished:
		get_parent().get_node("URLBar/TextEdit").editable = true
		dialog_finished = true

func _input(event):
	if event.is_action_released("choose"):
		if get_parent().get_node("URLBar").website_entered:
			if dialog != next_dialog:
				dialog_finished = false
				dialog_index = 0
				dialog = next_dialog
			if not dialog_finished:
				show_next_dialog()
			else:
				get_parent().get_node("NextButton").visible = true
			
		else:
			if not dialog_finished:
				show_next_dialog()
		
func show_next_dialog():
	$HBoxContainer/VBoxContainer/StoryContainer/VBoxContainer/StoryLabel.set_text(dialog[dialog_index])
		
	dialog_index += 1
	



func _on_TextureButton_pressed():
	get_tree().change_scene("res://Book.tscn")
