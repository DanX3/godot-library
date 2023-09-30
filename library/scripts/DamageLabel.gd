class_name DamageLabel extends Control

@onready var label = $Pivot/Label
@onready var shadow = $Pivot/Shadow

func init(damage: int, global_position: Vector2, target: Vector2):
	label.text = str(damage)
	shadow.text = str(damage)
	position = get_global_transform() * global_position
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", target, 0.5)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)
	tween.play()

func set_color(color: Color):
	label.modulate = color
