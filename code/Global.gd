extends Node2D


var shown_family_members = 0
var members = [
	'Lapu',
	'Riza',
	'Rubak',
	'Jano',
	'Maela'
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_shown_family_members(name):
	for index in range(members.size()):
		if name == members[index]:
			shown_family_members = index
			return
