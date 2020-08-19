extends MarginContainer

var dialog = [
	"Good morning class.",
	"This semester, we're going to be doing a fun new project. Hold on to your boots",
	"... The family tree project!",
	"Each one of you will be researching your family's history and presenting it to the class.",
	"You could spend time asking family members and looking through family albums...",
	"Or you could just use the internet.",
	"For homework, everyone should go online and learn a bit more about your ancestors.",
	"Have fun!"
]
var dialog_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_released("choose"):
		show_next_dialog()
		
func show_next_dialog():
	
	if dialog_index == dialog.size():
		get_parent().get_node("NextButton").visible = true
		return
	else:
		$HBoxContainer/VBoxContainer/StoryContainer/VBoxContainer/StoryLabel.set_text(dialog[dialog_index])


	dialog_index += 1


func _on_TextureButton_pressed():
	get_tree().change_scene("res://Computer.tscn")
