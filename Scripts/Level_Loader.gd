extends Node

# CREDITS TO STRAYBULLET FOR THIS CODE
# If called from Dialogic, call load_level_from_name() using Load block

# Enter level name here
enum LEVEL {
	MAIN_INTRO,
	LOGO,
	MAIN_MENU,
	SNOWDIN_FOREST,
}

# The level name will be mapped to the scene loaded here
var level_map: Dictionary = {
	LEVEL.MAIN_INTRO : load("res://Scenes/Cutscenes/main_intro.tscn"),
	LEVEL.LOGO : load("res://Scenes/Cutscenes/logo.tscn"),
	LEVEL.MAIN_MENU : load("res://Scenes/Rooms/main_menu.tscn"),
	LEVEL.SNOWDIN_FOREST : load("res://Scenes/Rooms/snowdin_forest.tscn"),
}

# Load the scene
func load_level(level: LEVEL):
	get_tree().change_scene_to_packed(level_map[level])

# Load the scene when called from code and/or Dialogic
# level name should be the capitalized one in LEVEL enum
func load_level_from_name(level_name: String):
	var next_level: LEVEL = LEVEL.get(level_name)
	if next_level != null:
		load_level(next_level)
	else:
		print("Level not found")
