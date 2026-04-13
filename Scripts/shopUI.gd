extends Control

var shop_items = [
	{
		"id": "torch",
		"name": "Torch",
		"description": "Lights dark spaces and helps with exploration."
	},
	{
		"id": "pickaxe",
		"name": "Stone Pickaxe",
		"description": "Useful for gathering hard materials."
	},
	{
		"id": "rope",
		"name": "Rope",
		"description": "Useful for traversal and reaching difficult places."
	}
]

@onready var item_container: VBoxContainer = $Panel/ItemContainer

func _ready() -> void:
	GameUI.register_shop_ui(self)
	visible = false
	_build_shop()

func _build_shop() -> void:
	for child in item_container.get_children():
		child.queue_free()
	
	for item in shop_items:
		var row := VBoxContainer.new()
		
		var name_label := Label.new()
		name_label.text = item["name"]
		
		var desc_label := Label.new()
		desc_label.text = item["description"]
		
		var buy_button := Button.new()
		buy_button.text = "Buy"
		buy_button.pressed.connect(_buy_item.bind(item["id"]))
		
		row.add_child(name_label)
		row.add_child(desc_label)
		row.add_child(buy_button)
		item_container.add_child(row)

func open_shop() -> void:
	visible = true

func close_shop() -> void:
	visible = false

func _buy_item(item_id: String) -> void:
	GameManager.add_item(item_id, 1)
	GameManager.add_knowledge_points(5)
	GameUI.show_temporary_message("Bought %s" % item_id.capitalize())
