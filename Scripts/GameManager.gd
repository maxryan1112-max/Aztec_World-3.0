extends Node

var gold: int = 50
var knowledge_points: int = 0
var inventory: Dictionary = {}

signal gold_changed(new_amount)
signal kp_changed(new_amount)
signal inventory_updated(new_inventory)

func _ready() -> void:
	emit_signal("gold_changed", gold)
	emit_signal("kp_changed", knowledge_points)
	emit_signal("inventory_updated", inventory)

func add_gold(amount: int) -> void:
	gold += amount
	emit_signal("gold_changed", gold)

func spend_gold(amount: int) -> bool:
	if gold >= amount:
		gold -= amount
		emit_signal("gold_changed", gold)
		return true
	return false

func add_item(item_id: String, amount: int = 1) -> void:
	if inventory.has(item_id):
		inventory[item_id] += amount
	else:
		inventory[item_id] = amount
	
	emit_signal("inventory_updated", inventory)

func remove_item(item_id: String, amount: int = 1) -> bool:
	if not has_item(item_id, amount):
		return false
	
	inventory[item_id] -= amount
	
	if inventory[item_id] <= 0:
		inventory.erase(item_id)
	
	emit_signal("inventory_updated", inventory)
	return true

func has_item(item_id: String, amount: int = 1) -> bool:
	return inventory.has(item_id) and inventory[item_id] >= amount

func add_knowledge_points(amount: int) -> void:
	knowledge_points += amount
	emit_signal("kp_changed", knowledge_points)

func reset_game_state() -> void:
	gold = 50
	knowledge_points = 0
	inventory.clear()
	
	emit_signal("gold_changed", gold)
	emit_signal("kp_changed", knowledge_points)
	emit_signal("inventory_updated", inventory)
