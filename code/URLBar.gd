extends Position2D

var websites = ['findmyfamily.com/manny_cruz', 'www.findmyfamily.com/manny_cruz']
var computer_window_dialog = ['No family found. Try again.', 'No family records available. Try again.', 'No results. Try again.', 'Loading...', 'Nope, nothing found.']
var computer_window_dialog_index = 0
var website_entered = false
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextEdit_text_entered(new_text):
	if new_text in websites:
		var computer_window = get_parent().get_node("ComputerWindow")
		computer_window.get_node('Label').set_text(computer_window_dialog[computer_window_dialog_index])
		computer_window_dialog_index = (computer_window_dialog_index + 1) % computer_window_dialog.size()
		website_entered = true
