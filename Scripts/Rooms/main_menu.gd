extends Node2D

@onready var menu_art = %MenuArt
@onready var menu_music = %BackgroundMusic
@onready var continue_label = %Continue
@onready var reset_label = %Reset
@onready var config_label = %Config
	# Update this for more text choices
@onready var choice_box = [
	[continue_label, reset_label],
	[config_label]
]
var row = 0
var col = 0
@onready var current_choice = choice_box[row][col]

# The current area of the save point
@export var area = "DUNES"
# Name of the areas
enum AREA { RUIN, DARK_RUIN, SNOWDIN, DUNES, STEAMWORKS, HOTLAND, NEWHOME }
# Change background art and music based on the area of the save point
var resource_map: Dictionary = {
	AREA.RUIN: { "position": Vector2(320, 374), "art": null, "music": preload("res://Asset/Musics/Menu/menu_ruins.ogg") },
	AREA.DARK_RUIN: { "position": Vector2(320, 374), "art": preload("res://Asset/Sprites/UI/Menu/Menu Ruin.png"), "music": preload("res://Asset/Musics/Menu/menu_darkruins.ogg") },
	AREA.SNOWDIN: { "position": Vector2(320, 374), "art": preload("res://Asset/Sprites/UI/Menu/Menu Snowdin.png"), "music": preload("res://Asset/Musics/Menu/menu_snowdin.ogg") },
	AREA.DUNES: { "position": Vector2(320, 342), "art": preload("res://Asset/Sprites/UI/Menu/Menu Dunes.png"), "music": preload("res://Asset/Musics/Menu/menu_wild_east.ogg") },
	AREA.STEAMWORKS: { "position": Vector2(320, 374), "art": preload("res://Asset/Sprites/UI/Menu/Menu Steamworks.png"), "music": preload("res://Asset/Musics/Menu/menu_steamworks.ogg") },
	AREA.HOTLAND: { "position": Vector2(320, 342), "art": preload("res://Asset/Sprites/UI/Menu/Menu Hotland.png"), "music": preload("res://Asset/Musics/Menu/menu_steamworks.ogg") },
	AREA.NEWHOME: { "position": Vector2(320, 282), "art": preload("res://Asset/Sprites/UI/Menu/Menu NewHome.png"), "music": preload("res://Asset/Musics/Menu/menu_ruins.ogg") }
}


func _ready():
	var enum_index: AREA = AREA.get(area)
	menu_art.position = resource_map[enum_index]["position"]
	menu_art.texture = resource_map[enum_index]["art"]
	menu_music.stream = resource_map[enum_index]["music"]
	menu_music.play()


func _process(delta):
	label_color_handler()
	change_selected_label_handler()
	select_label_handler()


# Update the current selected text with color yellow
# and unselected text with white/null
func label_color_handler():
	for array in choice_box:
		for label in array:
			if label == current_choice:
				label.set("theme_override_colors/font_color", Color.YELLOW)
			else:
				label.set("theme_override_colors/font_color", null)


# Update the selected text via movement keys
func change_selected_label_handler():
	if Input.is_action_just_pressed("move_right"):
		if col != len(choice_box[row]) - 1:
			col += 1
	if Input.is_action_just_pressed("move_left"):
		if col != 0:
			col -= 1
	if Input.is_action_just_pressed("move_down"):
		if row != len(choice_box) - 1:
			row += 1
			# If the row on top has more elements,
			# show the furthest element the row below has
			if col >= len(choice_box[row]):
				col = len(choice_box[row]) - 1
	if Input.is_action_just_pressed("move_up"):
		if row != 0:
			row -= 1
	current_choice = choice_box[row][col]


# Change the scene when pressing Accept on a label
func select_label_handler():
	if Input.is_action_just_pressed("accept"):
		# Do different things based on the selected labels
		match current_choice:
			continue_label:
				LevelLoader.load_level_from_name("SNOWDIN_FOREST")
			reset_label:
				pass
			config_label:
				pass
