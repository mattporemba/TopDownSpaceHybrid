extends CharacterBody2D


const FORWARD_THRUST = 200.0
const REVERSE_THRUST = -100.0
const STRAFE_THRUST = 150.0

var vector = Vector2(0.0, 0.0)

@onready var label = $Label

func _physics_process(delta):
	# Handle translational input.
	var y_thrust = Input.get_axis("forward_thrust", "reverse_thrust")
	# TODO: thrust seems reversed... not sure why
	if y_thrust && y_thrust < 0.0:
		vector.y += y_thrust * FORWARD_THRUST * delta
	elif y_thrust && y_thrust > 0.0:
		vector.y += y_thrust * REVERSE_THRUST * -1.0 * delta
	
	var x_thrust = Input.get_axis("left_strafe", "right_strafe")
	if x_thrust:
		vector.x += x_thrust * STRAFE_THRUST * delta
	
	velocity = vector

	move_and_slide()
	label.text = "vel: " + str(velocity) + ", vec: " + str(vector)
