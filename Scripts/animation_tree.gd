extends AnimationTree


# merchant.gd
var state_machine: AnimationNodeStateMachinePlayback

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func _on_market_area_body_entered(body):
	if body.is_in_group("player"):
		state_machine.travel("Wave")

func _on_market_area_body_exited(body):
	if body.is_in_group("player"):
		state_machine.travel("Idle")

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		if state_machine.get_current_node() in ["Wave", "WavePause"]:
			state_machine.travel("Talk")
