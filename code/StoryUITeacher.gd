extends MarginContainer

var dialog = [
	"Good morning class.",
	"This semester, we're going to be doing a fun new project. Hold on to your boots",
	"... The family tree project!",
	"Each one of you will be researching your family's history and presenting it to the class.",
	"You could spend time asking family members and looking through family albums...",
	"Or you could just use findmyfamily.com.",
	"For homework, everyone should go to findmyfamily.com and learn a bit more about your ancestors.",
	"Have fun!"
]
var dialog_index = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_released("choose"):
		show_next_dialog()
		
func show_next_dialog():
	dialog_index += 1
	
	if dialog_index == dialog.size():
		get_parent().get_node("NextButton").visible = true
		return
	
	$HBoxContainer/VBoxContainer/StoryContainer/VBoxContainer/StoryLabel.set_text(dialog[dialog_index])



func _on_TextureButton_pressed():
	get_tree().change_scene("res://Computer.tscn")
