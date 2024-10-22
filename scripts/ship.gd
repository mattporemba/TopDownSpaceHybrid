extends CharacterBody2D


const FORWARD_THRUST = 200.0
const REVERSE_THRUST = 100.0
const STRAFE_THRUST = 150.0
const MAX_SPEED = 1000.0

var vector = Vector2(0.0, 0.0)

@onready var label = $Label

func _physics_process(delta):
	# Handle translational input.
	# Godot treats "up" as negative?
	var y_thrust = Input.get_axis("reverse_thrust", "forward_thrust")
	if y_thrust && y_thrust > 0.0:
		print("forward!")
		vector.y += y_thrust * FORWARD_THRUST * delta * -1.0
	elif y_thrust && y_thrust < 0.0:
		print("reverse!")
		vector.y += y_thrust * REVERSE_THRUST * delta * -1.0
	
	var x_thrust = Input.get_axis("left_strafe", "right_strafe")
	if x_thrust:
		vector.x += x_thrust * STRAFE_THRUST * delta
	
	# Handle space braking
	if Input.is_action_pressed("space_brake"):
		if vector.x > 0.0:
			vector.x -= STRAFE_THRUST * delta
		elif vector.x < 0.0:
			vector.x += STRAFE_THRUST * delta
		if vector.y < 0.0:
			vector.y += REVERSE_THRUST * delta
			if vector.y > 0.0:
				vector.y = 0.0
		elif vector.y > 0.0:
			vector.y -= FORWARD_THRUST * delta
			if vector.y < 0.0:
				vector.y = 0.0
	
	velocity = vector

	move_and_slide()
	label.text = "vel: " + str(velocity) + ", vec: " + str(vector)
