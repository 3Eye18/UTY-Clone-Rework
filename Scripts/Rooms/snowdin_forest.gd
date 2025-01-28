extends Room

@onready var clover = preload("res://Scenes/Characters/clover.tscn")
@onready var spawn_point = %Marker2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_child(clover.instantiate())
	self.get_node("Clover").global_position = spawn_point.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_shadow_area_body_entered(body):
	if body.is_in_group("character"):
		body.get_node("Sprite2D").material.set_shader_parameter("darken_factor", 0.5)


func _on_shadow_area_body_exited(body):
	if body.is_in_group("character"):
		body.get_node("Sprite2D").material.set_shader_parameter("darken_factor", 1)


func _on_child_entered_tree(node):
	if node == self.get_node("Clover"):
		var limit_array = get_room_size($SnowdinForest)
		# Set limit of camera
		# 0 - left
		# 1 - top
		# 2 - right
		# 3 - bot
		node.get_node("Camera2D").set_limit(0, limit_array[0])
		node.get_node("Camera2D").set_limit(1, limit_array[1])
		node.get_node("Camera2D").set_limit(2, limit_array[2])
		node.get_node("Camera2D").set_limit(3, limit_array[3])
