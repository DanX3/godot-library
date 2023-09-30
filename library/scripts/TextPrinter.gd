class_name TextPrinter extends Node

signal finished

@export var autoplay:= false
@export var letter_delay = 0.1
@export var pause_char := '`'

var remaining_text := ""
var timer: Timer
var label: Label

const PauseDuration := 0.25

# Called when the node enters the scene tree for the first time.
func _ready():
	label = get_parent() as Label
	remaining_text = label.text
	label.text = ""
	
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	if autoplay:
		timer.start(letter_delay)
	

func play():
	timer.start(letter_delay)

func _on_timer_timeout():
	var next_letter = remaining_text.substr(0, 1)
	remaining_text = remaining_text.substr(1)
	
	# pause if there is a pause character
	timer.wait_time = letter_delay
	if next_letter == pause_char:
		timer.start(PauseDuration)
		return
	
	# if there is a space character, print it immediately
#	if next_letter == " ":
#		label.text += " "
#		next_letter = remaining_text.substr(0, 1)
#		remaining_text = remaining_text.substr(1)
	
	label.text += next_letter
	if remaining_text.is_empty():
		timer.stop()
		emit_signal("finished")
