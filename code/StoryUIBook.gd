extends MarginContainer


var dialog = [
	"After 48 hours of searching... here's the only family relic I could find.",
	"I hope I learn *something* about my family history.",
	"I'm too scared to open it - What if my family has no interesting story?",
	"I wonder what this strange symbol on the front means.",
	"Surely my family came from somewhere... Where to begin?"
]
var dialog_index = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	update_story_label()
	
	set_process_input(true)
	
func _input(event):
	if event.is_action_released("ui_accept"):
		update_story_label()

func update_manny_label():
	pass

func update_story_label():
	if dialog_index >= dialog.size():
		get_parent().get_node('BookSprite').shine()
		$HBoxContainer/VBoxContainer/StoryContainer/VBoxContainer/StoryLabel.set_text("Whoa, what's happening!")
	else:
		$HBoxContainer/VBoxContainer/StoryContainer/VBoxContainer/StoryLabel.set_text(dialog[dialog_index])
		dialog_index += 1
	
