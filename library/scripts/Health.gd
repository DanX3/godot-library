class_name Health extends Node

signal died
signal damage_taken

@export var max_health: int = 100
@export var damage_label_color := Color.RED
@export var health_bar: Range
@export var show_damage_label := true

@onready var health = max_health
var damage_label_scene = preload("res://library/scenes/damage_label.tscn")
var is_dead = false

func _ready():
	if health_bar != null:
		health_bar.max_value = max_health
		health_bar.value = max_health

func damage(damage: int): 
	if is_dead:
		return
	
	damage = min(health, damage)
	health -= damage
	emit_signal("damage_taken", damage)
	
	# create damage label
	if show_damage_label:
		var damage_label = damage_label_scene.instantiate() # as DamageLabel
		get_tree().root.add_child(damage_label)
		damage_label.init(damage, get_parent().global_position, \
			get_parent().global_position + 40.0 * Vector2.LEFT.rotated(randf_range(0.0, 2.0 * PI)))
		damage_label.set_color(damage_label_color)
	
	if health_bar != null:
		health_bar.value = health
	
	if health <= 0:
		is_dead = true
		emit_signal("died")
