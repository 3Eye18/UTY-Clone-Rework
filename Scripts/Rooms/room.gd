extends Node2D
class_name Room

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#---------------------------------top---------------------------------
#|								   |								 |
#|						    size.y * scale / 2						 |
#|								   |								 |
#left -- size.x * scale / 2 -- position -- size.x * scale / 2 -- right
#|								   |								 |
#|						    size.y * scale / 2						 |
#|								   |								 |
#---------------------------------bot---------------------------------
func get_room_size(sprite: Sprite2D) -> Array:
	var room_size = sprite.texture.get_size()
	var right = sprite.position.x + room_size.x * sprite.scale.x / 2
	var left = sprite.position.x - room_size.x * sprite.scale.x / 2
	var bot = sprite.position.y + room_size.y * sprite.scale.y / 2
	var top = sprite.position.y - room_size.y * sprite.scale.y / 2
	return [left, top, right, bot]
	
