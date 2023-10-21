extends Control

signal finished

#@export var messages: Array[DialogPair]
@export var characters: Array[DialogCharacter]

## the dialog is structured a following
## character_name What the character has to say...
## other_character_name And this is another character playing
## character_name The name is the id of the character and has to be a single word
@export_multiline var messages: String

@onready var printer = $TextMargin/Label/TextPrinter
@onready var player = $AnimationPlayer
@onready var label = $TextMargin/Label
@onready var arrow = $ContinueArrow
@onready var profile = $Pivot/Profile
@onready var sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

var messages_array: Array
var characters_map: Dictionary

func _ready():
	messages_array = messages.split("\n", false)
	# reverse the message order to pop_back the following message instead of pop_front
	messages_array.reverse()
	
	# characters map init
	for char in characters:
		characters_map[char.id] = char
	play_next()


func _input(event):
	if Input.is_action_just_pressed("ui_accept") and player.is_playing():
		play_next()


func play_next():
	if messages_array.is_empty():
		emit_signal("finished")
		hide()
		return
	
	var line = messages_array.pop_back() as String
	var first_space_index = line.find(" ")
	var name = line.substr(0, first_space_index)
	var message = line.substr(first_space_index + 1)
	var character = characters_map[name]
	
	profile.texture = character.picture
	sound.stream = character.voice
	printer.play(message)
	arrow.hide()
	player.stop()


func _on_text_printer_finished():
	arrow.show()
	player.play("move_arrow")
