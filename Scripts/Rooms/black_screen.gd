extends DialogicLayoutLayer

func _ready() -> void:
	Event.connect("screen_blacken", _on_screen_blacken)

func _on_screen_blacken():
	$AnimationPlayer.play("darken_screen")
	await $AnimationPlayer.animation_finished
	Event.emit_signal("screen_blacken_done")
