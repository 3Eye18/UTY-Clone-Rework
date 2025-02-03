extends DialogicLayoutLayer

func _ready() -> void:
	self.visible = false
	Dialogic.signal_event.connect(_on_dialogic_event)

func _on_dialogic_event(event: String):
	if event == "black":
		self.visible = true
	if event == "not_black":
		self.visible = false
