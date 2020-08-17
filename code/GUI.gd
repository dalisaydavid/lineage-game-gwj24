extends MarginContainer

const points_label_prefix = 'Story Points: '
var puzzle = null

func _ready():
	puzzle = get_parent().get_node('Puzzle')
	puzzle.connect('update_points', self, 'update_points_label', [puzzle])

func update_points_label(points):
	$HBoxContainer/LeftVBoxContainer/Label.set_text(points_label_prefix + str(puzzle.points))

