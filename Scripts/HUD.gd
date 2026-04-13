extends Control

@onready var interact_label: Label = $InteractPrompt
@onready var knowledge_label: Label = $KnowledgePoints
@onready var inventory_label: Label = $InventorySummary

func _ready() -> void:
	GameUI.register_hud(self)

func show_interact_prompt(text: String) -> void:
	interact_label.text = text
	interact_label.visible = true

func hide_interact_prompt() -> void:
	interact_label.visible = false

func update_knowledge(points: int) -> void:
	knowledge_label.text = "Knowledge: %d" % points

func update_inventory(items: Dictionary) -> void:
	var lines := []
	for key in items.keys():
		lines.append("%s x%d" % [key.capitalize(), items[key]])
	inventory_label.text = "\n".join(lines)
