extends RigidBody3D
# ───────────────────────────────────────────────
@export var thrust:            float = 20.0      # forward engine force
@export var torque_strength:   float = 5.0       # base rotational force
@export var mouse_sensitivity: float = 0.005     # radians of turn per pixel
@export var invert_y:          bool  = true      # classic “flight-sim” inverted pitch
# ───────────────────────────────────────────────
var _mouse_delta := Vector2.ZERO                 # accumulated mouse pixels this physics frame
# ───────────────────────────────────────────────
func _ready() -> void:
	# Capture / hide the cursor so you can keep moving the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	# Every MouseMotion event adds its relative movement to the per-frame bucket
	if event is InputEventMouseMotion:
		_mouse_delta += event.relative

func _physics_process(_delta: float) -> void:
	# ── Forward thrust ─────────────────────────
	if Input.is_action_pressed("move_forward"):
		apply_central_force(-transform.basis.z * thrust)
		print("Thrusting")
		
	# ── Mouse-driven pitch & yaw ───────────────
	if _mouse_delta != Vector2.ZERO:
		# X-axis mouse pixels → yaw around world-up (Y axis)
		var yaw_torque   = -_mouse_delta.x * mouse_sensitivity * torque_strength
		apply_torque(Vector3.UP * yaw_torque)

		# Y-axis mouse pixels → pitch around local-right (X axis)
		var pitch_pixels = _mouse_delta.y if invert_y else -_mouse_delta.y
		var pitch_torque =  pitch_pixels * mouse_sensitivity * torque_strength
		apply_torque(Vector3.RIGHT * pitch_torque)

		_mouse_delta = Vector2.ZERO   # clear for next physics tick

	# ── Optional roll (keyboard) ───────────────
	if Input.is_action_pressed("roll_left"):
		apply_torque(Vector3.BACK * -torque_strength)
	if Input.is_action_pressed("roll_right"):
		apply_torque(Vector3.BACK *  torque_strength)
