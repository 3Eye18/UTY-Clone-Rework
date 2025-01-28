extends Node2D
class_name Room

@onready var clover = preload("res://Scenes/Characters/clover.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_room_size(sprite: Sprite2D):
	print(sprite.texture.get_size())
