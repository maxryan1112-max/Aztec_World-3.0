extends Node

var hud: Control
var dialogue_ui: Control
var shop_ui: Control

func register_hud(node: Control) -> void:
	hud = node

func register_dialogue_ui(node: Control) -> void:
	dialogue_ui = node

func register_shop_ui(node: Control) -> void:
	shop_ui = node

func show_interact_prompt(text: String) -> void:
	if hud:
		hud.show_interact_prompt(text)

func hide_interact_prompt() -> void:
	if hud:
		hud.hide_interact_prompt()

func update_knowledge(points: int) -> void:
	if hud:
		hud.update_knowledge(points)

func update_inventory(items: Dictionary) -> void:
	if hud:
		hud.update_inventory(items)

func open_dialogue(data: Dictionary) -> void:
	if dialogue_ui:
		dialogue_ui.open_dialogue(data)

func open_shop() -> void:
	if shop_ui:
		shop_ui.open_shop()

func show_temporary_message(text: String) -> void:
	print(text) # replace later with actual toast UI
