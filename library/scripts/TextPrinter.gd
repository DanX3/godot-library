## component that automatically prints a string to a label
## it expects the Label as its parent
class_name TextPrinter extends Node

signal finished

@export var letter_delay = 0.1
@export var pause_chars :Array[String] = [',', '.']

var remaining_text := ""
var timer: Timer
var label: Label

const PauseDuration := 0.25

# Called when the node enters the scene tree for the first time.
func _ready():
	label = get_parent() as Label
	
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	

func play(message: String):
	remaining_text = message
	label.text = ""
	timer.start(letter_delay)

func _on_timer_timeout():
	var next_letter = remaining_text.substr(0, 1)
	remaining_text = remaining_text.substr(1)
	
	# pause if there is a pause character
	timer.wait_time = letter_delay
	label.text += next_letter
	if pause_chars.has(next_letter):
		timer.start(PauseDuration)
	
	# if there is a space character, print it immediately
#	if next_letter == " ":
#		label.text += " "
#		next_letter = remaining_text.substr(0, 1)
#		remaining_text = remaining_text.substr(1)
	
	if remaining_text.is_empty():
		timer.stop()
		emit_signal("finished")
