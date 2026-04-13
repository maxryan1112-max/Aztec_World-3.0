extends CharacterBody3D

@onready var anim_tree: AnimationTree = $girl/AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = anim_tree["parameters/playback"]
@onready var proximity_area: Area3D = $ProximityArea

const WAVE_COOLDOWN := 10.0
const WAVE_CHANCE   := 0.35

var wave_timer      := 0.0
var player_nearby   := false



func _ready() -> void:
	anim_tree.active = true
	state_machine.start("Idle")
	proximity_area.body_entered.connect(_on_player_entered)
	proximity_area.body_exited.connect(_on_player_exited)

func _on_player_entered(body: Node3D) -> void:
	##print("body entered: ", body.name)
	if body.is_in_group("player"):
		print("player detected, current state: ", state_machine.get_current_node())
		player_nearby = true
		if state_machine.get_current_node() == "Idle":
			state_machine.travel("Wave")
			print("travelling to Wave")

func _on_player_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
		wave_timer = 0.0

func _physics_process(delta: float) -> void:
	_handle_test_input()
	_handle_random_wave(delta)
	_check_wave_finished()
	
func _check_wave_finished() -> void:
	if state_machine.get_current_node() == "Idle" and player_nearby:# wave finished, timer is ready to count again
		pass  # timer already counts in _handle_random_wave

func _handle_test_input() -> void:
	var current := state_machine.get_current_node()
	if current == "Wave":
		return

	if Input.is_action_just_pressed("npc_talk"):
		if current == "Talk":
			state_machine.travel("Idle")
		else:
			state_machine.travel("Talk")

func _handle_random_wave(delta: float) -> void:
	print("player_nearby: ", player_nearby, " | state: ", state_machine.get_current_node())
	if not player_nearby:
		wave_timer = 0.0
		return

	var current := state_machine.get_current_node()
	if current == "Idle":
		wave_timer += delta
		print("wave_timer: ", wave_timer)  # debug, remove later
		if wave_timer >= WAVE_COOLDOWN:
			wave_timer = 0.0
			if randf() < WAVE_CHANCE:
				state_machine.travel("Wave")

	wave_timer += delta
	if wave_timer >= WAVE_COOLDOWN:
		wave_timer = 0.0
		if randf() < WAVE_CHANCE:
			state_machine.travel("Wave")
			
			

	   
