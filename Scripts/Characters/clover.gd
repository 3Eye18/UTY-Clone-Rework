extends CharacterBody2D

@onready var animation_tree = $AnimationTree
@onready var camera = %Camera2D

@export var speed: float = 75
@export var first_blend_position = Vector2(0, -1)

var hardcoded_can_move: bool = true
var can_move: bool = true
var finger_gun: bool = false

func _ready():
	animation_tree.set("parameters/Idle/blend_position", first_blend_position)


func _physics_process(delta):
	if hardcoded_can_move:
		if can_move and finger_gun:
			animation_tree.get("parameters/playback").travel("finger_gun")
		elif can_move and !finger_gun:
			var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
			
			if direction == Vector2.ZERO:
				animation_tree.get("parameters/playback").travel("Idle")
			else:
				animation_tree.get("parameters/playback").travel("Walk")
				animation_tree.set("parameters/Idle/blend_position", direction)
				animation_tree.set("parameters/Walk/blend_position", direction)
			
			velocity = direction * speed
			
			move_and_slide()
		elif !can_move and !finger_gun:
			animation_tree.get("parameters/playback").travel("Idle")
	
	
