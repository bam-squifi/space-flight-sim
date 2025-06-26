extends RigidBody3D

@export var thrust = 40.0
@export var torque_strength = 5.0
@export var max_roll_speed: float = 2.0 # radians per second
@export var roll_acceleration: float = 4.
@export var damp: float = 2.0  # how aggressively we brake

func _physics_process(_delta):
	# Forward thrust
	if Input.is_action_pressed("strafe_forward"):
		apply_central_force(-transform.basis.x * thrust)
	if Input.is_action_pressed("strafe_back"):
		apply_central_force(transform.basis.x * thrust)
	
	if Input.is_action_pressed("strafe_up"):
		apply_central_force(transform.basis.y * thrust * .5)
	if Input.is_action_pressed("strafe_down"):
		apply_central_force(-transform.basis.y * thrust * .5)
		
	if Input.is_action_pressed("strafe_left"):
		apply_central_force(transform.basis.z * thrust * .5)
	if Input.is_action_pressed("strafe_right"):
		apply_central_force(-transform.basis.z * thrust * .5)

	# Yaw
	if Input.is_action_pressed("yaw_left"):
		apply_torque(Vector3.UP * -torque_strength)
	if Input.is_action_pressed("yaw_right"):
		apply_torque(Vector3.UP * torque_strength)

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
	else:
		self.angular_damp = damp
		

	
		
	print("Current Roll Speed: ", local_angular_velocity)

	# Pitch	
	if Input.is_action_pressed("pitch_up"):
		apply_torque(Vector3.BACK * -torque_strength)
	if Input.is_action_pressed("pitch_down"):
		apply_torque(Vector3.BACK * torque_strength)
		
	# ── Get forward speed (in m/s) ─────────────────────────────
	var forward_dir = -transform.basis.x.normalized()
	var forward_speed = linear_velocity.dot(forward_dir)
	print("Forward speed: ", forward_speed, " m/s")
