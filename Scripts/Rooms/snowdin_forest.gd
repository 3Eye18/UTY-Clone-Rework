extends Room

@onready var clover = preload("res://Scenes/Characters/clover.tscn")
@onready var spawn_point = $SnowdinForest/Marker2D
@onready var cutscene_point = $"SnowdinForest/Cutscene Trigger/Marker2D"


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
	if node == get_node("Clover"):
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


func _on_cutscene_trigger_body_entered(body):
	if body == get_node("Clover"):
		# Stop Clover from moving
		body.hardcoded_can_move = false
		
		# Move horizontally (x-axis)
		var tween = get_tree().create_tween()
		tween.tween_property(
			body, 
			"position:x", 
			cutscene_point.global_position.x, 
			1
		)
		# Set blend position for horizontal movement
		if body.global_position.x > cutscene_point.global_position.x:
			body.animation_tree.set("parameters/Walk/blend_position", Vector2(-1, 0))
		else:
			body.animation_tree.set("parameters/Walk/blend_position", Vector2(1, 0))
		await tween.finished

		# Switch to idle animation and set blend position
		body.animation_tree.get("parameters/playback").travel("Idle")
		body.animation_tree.set("parameters/Idle/blend_position", Vector2(0, -1))
		
		# Move camera upward
		tween = get_tree().create_tween()
		tween.tween_interval(1)
		tween.tween_property(
			body.camera, 
			"offset:y", 
			-60, 
			3
		)
		await tween.finished
		
		body.hardcoded_can_move = true  # Re-enable movement
		$"SnowdinForest/Cutscene Trigger".queue_free()  # Remove the trigger
		
