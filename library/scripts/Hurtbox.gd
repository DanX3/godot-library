class_name HurtBox extends Area2D

signal hurt(damage)

@export var health: Health

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if area is HitBox:
		var hitbox = area # as HitBox
		if health != null:
			health.damage(hitbox.damage)
		emit_signal("hurt", hitbox.damage)
