extends Node

class_name Inventory

signal added(item: String)
signal used(item: String)

## Dictionary<String, int> representing item name and amount held
var inventory: Dictionary = {}

func _ready():
	add_to_group("persist")
	add("heavy_stone")
	add("rainbow_feather")
	add("rainbow_feather")
	add("rainbow_feather")
	print("using non held item ", use("unobtained_item"))
	print("using held item ", use("rainbow_feather"))

func has(item: String) -> bool:
	return inventory.has(item)


## adds the item to the inventory emitting a signal
func add(item: String):
	if inventory.has(item):
		inventory[item] += 1
	else:
		inventory[item] = 1

func use(item: String) -> bool:
	if not inventory.has(item):
		return false
	
	inventory[item] -= 1
	emit_signal("used", item)
	if inventory[item] == 0:
		inventory.erase(item)
	return true

func save():
	return inventory
