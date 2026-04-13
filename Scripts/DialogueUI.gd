extends Control

@onready var speaker_label: Label = $Panel/SpeakerLabel
@onready var text_label: RichTextLabel = $Panel/DialogueText
@onready var choices_container: VBoxContainer = $Panel/ChoicesContainer

func _ready() -> void:
	GameUI.register_dialogue_ui(self)
	visible = false

func open_dialogue(data: Dictionary) -> void:
	visible = true
	speaker_label.text = data.get("speaker", "")
	text_label.text = data.get("text", "")
	
	for child in choices_container.get_children():
		child.queue_free()
	
	for choice in data.get("choices", []):
		var button := Button.new()
		button.text = choice["text"]
		button.pressed.connect(_on_choice_selected.bind(choice["action"]))
		choices_container.add_child(button)

func _on_choice_selected(action: String) -> void:
	match action:
		"open_shop":
			visible = false
			GameUI.open_shop()
		"merchant_lore":
			open_dialogue({
				"speaker": "Market Merchant",
				"text": "These lands remember what people build, what they trade, and what they leave behind.",
				"choices": [
					{"text": "Show me your tools.", "action": "open_shop"},
					{"text": "Goodbye.", "action": "close"}
				]
			})
		"close":
			visible = false
