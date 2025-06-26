extends RigidBody3D

@export var thrust = 20.0
@export var torque_strength = 1.0
@export var max_roll_speed: float = 2.0 # radians per second
@export var roll_acceleration: float = 3.

func _physics_process(_delta):
	# Forward thrust
	if Input.is_action_pressed("strafe_forward"):
		apply_central_force(-transform.basis.x * thrust)
	if Input.is_action_pressed("strafe_back"):
		apply_central_force(transform.basis.x * thrust / 2)
	
	if Input.is_action_pressed("strafe_up"):
		apply_central_force(transform.basis.y * thrust / 2)
	if Input.is_action_pressed("strafe_down"):
		apply_central_force(-transform.basis.y * thrust / 2)
		
	if Input.is_action_pressed("strafe_left"):
		apply_central_force(transform.basis.z * thrust / 2)
	if Input.is_action_pressed("strafe_right"):
		apply_central_force(-transform.basis.z * thrust / 2)

	# Yaw
	if Input.is_action_pressed("yaw_left"):
		apply_torque(Vector3.UP * -torque_strength / 2)
	if Input.is_action_pressed("yaw_right"):
		apply_torque(Vector3.UP * torque_strength / 2)

	# ----------------------------
	# Roll
	# ---------------------------
	var local_angular_velocity = to_local(Vector3.ZERO + angular_velocity)
	var current_roll_speed = local_angular_velocity.z
	
	if Input.is_action_pressed("roll_left"):
		if current_roll_speed > -max_roll_speed:
			apply_torque(transform.basis.x * roll_acceleration)
	elif Input.is_action_pressed("roll_right"):
		if current_roll_speed < max_roll_speed:
			apply_torque(transform.basis.x * -roll_acceleration)
		
	print("Current Roll Speed: ", current_roll_speed)

	# Pitch	
	if Input.is_action_pressed("pitch_up"):
		apply_torque(Vector3.BACK * -torque_strength / 2)
	if Input.is_action_pressed("pitch_down"):
		apply_torque(Vector3.BACK * torque_strength / 2)
		
	# ── Get forward speed (in m/s) ─────────────────────────────
	var forward_dir = -transform.basis.x.normalized()
	var forward_speed = linear_velocity.dot(forward_dir)
	print("Forward speed: ", forward_speed, " m/s")
