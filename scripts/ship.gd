extends CharacterBody2D


const FORWARD_THRUST = 200.0
const REVERSE_THRUST = 100.0
const STRAFE_THRUST = 150.0
const MAX_SPEED = 1000.0
const YAW_SPEED = 100.0

const MOUSE_ROT_OFFSET = 90.0

var ship_vector = Vector2(0.0, 0.0)

@onready var label = $Label

func _physics_process(delta):
	# TODO: Max yaw speed
	look_at(get_global_mouse_position())
	
	# Handle translational input.
	# These are messed up:
	#	Sprite is rotated 90 degrees
	#	Using x axis for forward/reverse, y axis for lateral
	var thrust_vector: Vector2
	var y_thrust = Input.get_axis("reverse_thrust", "forward_thrust")
	if y_thrust && y_thrust > 0.0:
		thrust_vector.x = y_thrust * FORWARD_THRUST
	elif y_thrust && y_thrust < 0.0:
		thrust_vector.x = y_thrust * REVERSE_THRUST
	
	var x_thrust = Input.get_axis("left_strafe", "right_strafe")
	if x_thrust:
		thrust_vector.y = x_thrust * STRAFE_THRUST
	
	ship_vector += thrust_vector.rotated(rotation)
	velocity = ship_vector * delta
	move_and_slide()
	
	
	
	## Handle space braking
	#if Input.is_action_pressed("space_brake"):
		#if ship_vector.x > 0.0:
			#ship_vector.x -= STRAFE_THRUST * delta
		#elif ship_vector.x < 0.0:
			#ship_vector.x += STRAFE_THRUST * delta
		#if ship_vector.y < 0.0:
			#ship_vector.y += REVERSE_THRUST * delta
			#if ship_vector.y > 0.0:
				#ship_vector.y = 0.0
		#elif ship_vector.y > 0.0:
			#ship_vector.y -= FORWARD_THRUST * delta
			#if ship_vector.y < 0.0:
				#ship_vector.y = 0.0
	#
#
	#label.text = "vel: " + str(velocity) + ", vec: " + str(ship_vector)
	#
	## Handle yaw
	#var mouseInput = Input.get_last_mouse_velocity()
	#if mouseInput:
		#if mouseInput.x > 0:
			#rotation_degrees += YAW_SPEED * delta
		#elif mouseInput.x < 0:
			#rotation_degrees -= YAW_SPEED * delta
	#
	#velocity = ship_vector.rotated(rotation_degrees)
	#move_and_slide()
