extends Room


# Called when the node enters the scene tree for the first time.
func _ready():
	get_room_size($SnowdinForest)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_shadow_area_body_entered(body):
	$Clover.get_node("Sprite2D").material.set_shader_parameter("darken_factor", 0.5)


func _on_shadow_area_body_exited(body):
	$Clover.get_node("Sprite2D").material.set_shader_parameter("darken_factor", 1)
