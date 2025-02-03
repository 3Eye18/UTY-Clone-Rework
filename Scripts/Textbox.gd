@tool
extends DialogicLayoutLayer
class_name Textbox

signal finished_displaying

# Configs for Text
@export_group("Text")

@export_subgroup("Text Delay")
@export var LETTER_TIME = 0.03
@export var SPACE_TIME = 0.06
@export var PUNCTUATION_TIME = 0.12

@export_subgroup("Size")
@export var text_size: int = 15

@export_subgroup("Color")
@export var text_use_global_color: bool = true
@export var text_custom_color: Color = Color.WHITE

@export_subgroup('Font')
@export var text_use_global_font: bool = true
@export_file('*.ttf', '*.tres') var normal_font: String = ""
@export_file('*.ttf', '*.tres') var bold_font: String = ""
@export_file('*.ttf', '*.tres') var italics_font: String = ""
@export_file('*.ttf', '*.tres') var bold_italics_font: String = ""

# Configs for Text Sound
@export_group('Sounds')

@export_subgroup('Typing Sounds')
@export var typing_sounds_enabled: bool = true
@export var typing_sounds_mode: DialogicNode_TypeSounds.Modes = DialogicNode_TypeSounds.Modes.INTERRUPT
@export_dir var typing_sounds_sounds_folder: String = "res://addons/dialogic/Example Assets/sound-effects/"
@export_file("*.wav", "*.ogg", "*.mp3") var typing_sounds_end_sound: String = ""
@export_range(1, 999, 1) var typing_sounds_every_nths_character: int = 1
@export_range(0.01, 4, 0.01) var typing_sounds_pitch: float = 1.0
@export_range(0.0, 3.0) var typing_sounds_pitch_variance: float = 0.0
@export_range(-80, 24, 0.01) var typing_sounds_volume: float = -10
@export_range(0.0, 10) var typing_sounds_volume_variance: float = 0.0
@export var typing_sounds_ignore_characters: String = " "


@onready var margin_container = $MarginContainer
@onready var timer = $LetterDisplayTimer
@onready var label = $MarginContainer/HBoxContainer/Label
@onready var audio_player = $AudioStreamPlayer
@onready var animated_sprite = $AnimatedSprite2D

var text = ""
var sprite = "none"
var letter_index = 0


## The default layout base scene.

@export var canvas_layer: int = 1
@export var follow_viewport: bool = false

@export_subgroup("Global")
@export var global_bg_color: Color = Color(0, 0, 0, 0.9)
@export var global_font_color: Color = Color("white")
@export_file('*.ttf', '*.tres') var global_font: String = ""
@export var global_font_size: int = 18


func _apply_export_overrides() -> void:
	if !is_inside_tree():
		await ready
	
	## FONT SETTINGS
	_apply_text_settings()
	
	## TYPING SOUNDS
	#_apply_sounds_settings()


## Applies all text settings to the scene.
func _apply_text_settings() -> void:
	var dialog_text: DialogicNode_DialogText = %DialogicNode_DialogText
	#dialog_text.alignment = text_alignment as DialogicNode_DialogText.Alignment

	dialog_text.add_theme_font_size_override(&"normal_font_size", text_size)
	dialog_text.add_theme_font_size_override(&"bold_font_size", text_size)
	dialog_text.add_theme_font_size_override(&"italics_font_size", text_size)
	dialog_text.add_theme_font_size_override(&"bold_italics_font_size", text_size)

	if text_use_global_color:
		dialog_text.add_theme_color_override(&"default_color", get_global_setting(&'font_color', text_custom_color) as Color)
	else:
		dialog_text.add_theme_color_override(&"default_color", text_custom_color)

	if text_use_global_font and get_global_setting(&'font', false):
		dialog_text.add_theme_font_override(&"normal_font", load(get_global_setting(&'font', '') as String) as Font)
	elif !normal_font.is_empty():
		dialog_text.add_theme_font_override(&"normal_font", load(normal_font) as Font)
	if !bold_font.is_empty():
		dialog_text.add_theme_font_override(&"bold_font", load(bold_font) as Font)
	if !italics_font.is_empty():
		dialog_text.add_theme_font_override(&"italics_font", load(italics_font) as Font)
	if !bold_italics_font.is_empty():
		dialog_text.add_theme_font_override(&"bold_italics_font", load(bold_italics_font) as Font)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func display_text(text_to_display: String, speech_sfx: AudioStream, sprite_name: String):
	text = text_to_display
	sprite = sprite_name
	
	if sprite == "none":
		margin_container.add_theme_constant_override("margin_left", 30)
	else:
		margin_container.add_theme_constant_override("margin_left", 270)
	
	label.text = ""
	audio_player.stream = speech_sfx
	
	_display_letter()


func _display_letter():
	if letter_index < text.length():
		label.text += text[letter_index]
		
		letter_index += 1
		if letter_index >= text.length():
			animated_sprite.stop()
			finished_displaying.emit()
			return
		
		match text[letter_index]:
			"!", ",", "?", ":":
				timer.start(PUNCTUATION_TIME)
			" ":
				timer.start(SPACE_TIME)
			".":
				timer.start(PUNCTUATION_TIME * 2)
			_:
				timer.start(LETTER_TIME)
				animated_sprite.play(sprite)
				audio_player.play()


func _skip_text():
	timer.stop()
	label.text = text


func _on_letter_display_timer_timeout():
	_display_letter()
