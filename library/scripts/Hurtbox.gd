## The Hurtbox actively monitors for collision with the Hitbox\
## Correctly setup the collision layer/mask
## If Health is populates automatically communicates the damage
## Optionally can filter for Hitboxes with different IDs to avoid being hit multiple
## times by the same hitbox. The hitbox must refresh its ID to deal damage again
class_name HurtBox extends Area2D

signal hurt(damage)

@export var health: Health
@export var remembers_id = false
var last_id = -1

func _ready() -> void:
	monitorable = false
	connect("area_entered", _on_area_entered)

func _on_area_entered(area):
	# hit only with hitboxes
	if not area is HitBox:
		return
	var hitbox = area as HitBox
	
	# skip collision if the last hitbox ID is the same as this one
	if remembers_id:
		if area.id == last_id:
			return
		last_id = area.id
	
	if health != null:
		health.damage(hitbox.damage)
	
	hitbox.hit.emit()
	hurt.emit(hitbox.damage)
