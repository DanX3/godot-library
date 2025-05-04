extends Node

@onready var actionLabel = %ListenAction
@onready var consumeLabel = %ConsumedAction
@onready var listener = $InputListener
@onready var listenButton = $CanvasLayer/VBoxContainer/HBoxContainer/Listen
@onready var consumeButton = $CanvasLayer/VBoxContainer/HBoxContainer/Consume

func _on_listen_pressed() -> void:
	listener.start_listening()
	listenButton.disabled = true
	consumeButton.disabled = false
	actionLabel.text = "..."
	consumeLabel.text = "..."


func _on_consume_pressed() -> void:
	var event = listener.consume() as ComboListener.ListenerEvent
	actionLabel.text = "..."
	consumeLabel.text = "%s - %s" % [event.action, str(event.type)]
	listenButton.disabled = false
	consumeButton.disabled = true


func _on_input_listener_changed_action(action: String, event: ComboListener.EventType) -> void:
	actionLabel.text = "%s - %s" % [action, str(event)]
	
