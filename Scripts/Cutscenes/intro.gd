extends DialogicBackground

signal finished_displaying

@onready var animation = $AnimationPlayer
@onready var timer = %Timer
@onready var audio_player = %AudioStreamPlayer
@onready var label = %Label

@export var LETTER_TIME = 0.06
@export var SPACE_TIME = 0.12
@export var PUNCTUATION_TIME = 0.2

var text
var letter_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(change_text)
	# Get the text from intro_text variable from Dialogic timeline
	text = Dialogic.VAR.intro_text
	# Play the according animation after getting its name from Dialogic timeline
	animation.play(Dialogic.VAR.intro_animation)
	_display_letter()


func _display_letter() -> void:
	if letter_index < text.length():
		label.text += text[letter_index]
		
		letter_index += 1
		if letter_index >= text.length():
			finished_displaying.emit()
			return
		
		match text[letter_index]:
			"!", ",", "?", ":", ".":
				timer.start(PUNCTUATION_TIME)
				audio_player.play()
			" ":
				timer.start(SPACE_TIME)
			_:
				timer.start(LETTER_TIME)
				audio_player.play()

# Called when receiving ANY signal frmo Dialogic timeline
func change_text(event: String) -> void:
	if event == "text_changed":
		letter_index = 0
		text = Dialogic.VAR.intro_text
		label.text = ""
		_display_letter()


func _on_timer_timeout() -> void:
	_display_letter()
