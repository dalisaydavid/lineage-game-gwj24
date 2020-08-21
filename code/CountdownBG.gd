extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Position2D/Label.set_text(str(ceil($Timer.time_left)))

func start():
	self.visible = true
	$Timer.start()
	
func _on_Timer_timeout():
	get_parent().start()
	queue_free()
		
