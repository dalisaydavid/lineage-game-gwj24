extends Node2D


const NUM_FAMILY_MEMBERS = 5

var member_scene_mapping = [
	'res://Lapu.tscn',
	'res://Riza.tscn',
	'res://Rubak.tscn',
	'res://Jano.tscn',
	'res://Maela.tscn',
	'res://End.tscn'
]

# Called when the node enters the scene tree for the first time.
func _ready():
#	set_process_input(false)
	
	$Sprite.frame = get_node("/root/Global").shown_family_members
	show_next_family_member()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func _input(event):
#	if event.is_action_released("choose"):
#		show_next_family_member()

func unshine():
	var tween = get_node("Light2D/UnshineTween")
	tween.interpolate_property(
		get_node('Light2D'), 
		'energy',
		3,
		0, 
		5,
		Tween.TRANS_QUART, 
		Tween.EASE_OUT,
		1.0
	)
	tween.start()

func show_next_family_member():
	if get_node("/root/Global").shown_family_members >= NUM_FAMILY_MEMBERS:
		return
	
	unshine()


func _on_UnshineTween_tween_started(object, key):
	$Sprite.frame = get_node("/root/Global").shown_family_members+1
	$Light2D.global_position = get_node('Position2D' + str(get_node("/root/Global").shown_family_members)).global_position
	get_node("/root/Global").shown_family_members += 1


func _on_UnshineTween_tween_all_completed():
	get_tree().change_scene(member_scene_mapping[get_node("/root/Global").shown_family_members])
