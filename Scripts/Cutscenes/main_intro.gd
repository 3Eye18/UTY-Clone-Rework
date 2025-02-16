extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.start_timeline("intro")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("accept"):
		Event.emit_signal("screen_blacken")
		await Event.screen_blacken_done
		Dialogic.start_timeline("blackscreen")
		LevelLoader.load_level_from_name("LOGO")
