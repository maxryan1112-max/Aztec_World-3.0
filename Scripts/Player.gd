extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var mouse_sensitivity := 0.001
@export var horizontal_sensitivity := 0.0005
@export var pitch_limit := deg_to_rad(85)

@onready var head := $Head
@onready var camera := $Head/Camera3D


var _pitch := 0.0
var _is_xr := false

func _ready():
	# Try to start OpenXR
	var xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.initialize():
		get_viewport().use_xr = true
		_is_xr = true
		print("XR started successfully")
		#push the tracking origin down so camera sits at the right height
		xr_origin.position.y = -0.5
		# Connect controller buttons
		right_controller.button_pressed.connect(_on_right_pressed)
		left_controller.button_pressed.connect(_on_left_pressed)
	else:
		# Fall back to mouse/keyboard
		_is_xr = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		print("Running in desktop mode")

func _on_right_pressed(name: String):
	if name == "trigger_click" and is_on_floor():
		velocity.y = JUMP_VELOCITY

func _on_left_pressed(name: String):
	pass

func _unhandled_input(event):
	# Only handle mouse look in desktop mode
	if _is_xr:
		return

	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * horizontal_sensitivity)
		_pitch -= event.relative.y * mouse_sensitivity
		_pitch = clamp(_pitch, -pitch_limit, pitch_limit)
		head.rotation.x = _pitch

	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	if _is_xr:
		_handle_xr_movement()
	else:
		_handle_keyboard_movement()

	move_and_slide()

func _handle_xr_movement():
	# Right thumbstick — forward/back and strafe
	var stick : Vector2 = right_controller.get_vector2("primary")

	# Jump with left controller trigger
	if left_controller.is_button_pressed("trigger_click") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if stick.length() > 0.1:
		# Move relative to where the headset is facing (horizontal only)
		var cam_basis : Basis = camera.global_transform.basis
		var forward : Vector3 = -cam_basis.z
		var right : Vector3 = cam_basis.x
		forward.y = 0
		right.y = 0
		forward = forward.normalized()
		right = right.normalized()

		var direction : Vector3 = (forward * stick.y) + (right * stick.x)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

func _handle_keyboard_movement():
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("move_left", "move_right", "move_foward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
