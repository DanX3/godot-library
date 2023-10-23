## component that automatically prints a string to a label
## it expects the Label as its parent
class_name TextPrinter extends Node

signal finished

@export var letters_per_second = 10.0
@export var pause_chars :Array[String] = [',', '.', '?']
@export var sound_player: AudioStreamPlayer2D

var letter_delay
var remaining_text := ""
var timer: Timer
var label: Label

const PauseDuration := 0.25

# Called when the node enters the scene tree for the first time.
func _ready():
	letter_delay = 1.0 / letters_per_second
	print(letter_delay)
	label = get_parent() as Label
	
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)


func play(message: String):
	remaining_text = message
	label.text = ""
	timer.start(letter_delay)
	sound_player.play()
	sound_player.stream_paused = false


func _on_timer_timeout():
	var next_letter = remaining_text.substr(0, 1)
	remaining_text = remaining_text.substr(1)
	
	if sound_player and sound_player.stream_paused:
		sound_player.stream_paused = false
	if sound_player and randf_range(0.0, 1.0) < 0.5:
		var pitch = floor(10.0 * randf_range(0.8, 1.2)) * 0.1
		sound_player.pitch_scale = pitch
	
	# pause if there is a pause character
	timer.wait_time = letter_delay
	label.text += next_letter
	if pause_chars.has(next_letter):
		timer.start(PauseDuration)
		if sound_player:
			sound_player.stream_paused = true
		return
	
	if remaining_text.is_empty():
		timer.stop()
		emit_signal("finished")
		if sound_player:
			sound_player.playing = false
