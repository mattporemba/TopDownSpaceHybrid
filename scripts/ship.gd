extends CharacterBody2D

# Movement
const FORWARD_THRUST = 200.0
const REVERSE_THRUST = 100.0
const STRAFE_THRUST = 150.0
const MAX_SPEED = 1000.0  # TODO: Implement
const YAW_SPEED = 3.5
var ship_vector = Vector2(0.0, 0.0)
@onready var label = $Label

# Shooting
signal shoot(bullet, direction, location, bullet_velocity: Vector2)
var bullet_speed = 100.0
var Bullet = preload("res://scenes/bullet.tscn")

# Debug
const DEBUG_SHIP_DIRECTION_LINE_MAGNITUDE = 100.0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_fire"):
		var bullet_velocity = Vector2(velocity.x + bullet_speed, velocity.y)
		shoot.emit(Bullet, rotation, position, bullet_velocity)


func _physics_process(delta):
	handle_rotation(delta)
	
	# Handle space braking or translational movement.
	if Input.is_action_pressed("space_brake"):
		handle_space_brake(delta)
	else:
		var thrust_vector = handle_translational_movement()
		ship_vector += thrust_vector.rotated(rotation)
		velocity = ship_vector * delta
		move_and_slide()
	
	label.text = "rot: " + str(rotation) + "\nvel x: " + str(velocity.x) + "\nvel y : " + str(velocity.y) + "\nship x: " + str(ship_vector.x) + "\nship y: " + str(ship_vector.y)


func handle_rotation(delta):
	var target = get_global_mouse_position()
	var direction = (target - global_position)
	var angle_to = transform.x.angle_to(direction)
	rotate(sign(angle_to) * min(delta * YAW_SPEED, abs(angle_to)))


func handle_translational_movement() -> Vector2:
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
	return thrust_vector


func handle_space_brake(delta):
	# Again, acount for having velocity x and y reversed.
	var brake_vector: Vector2
	
	# Lateral braking
	if ship_vector.rotated(rotation * -1.0).y < 0.0:
		brake_vector.y = STRAFE_THRUST
	elif ship_vector.rotated(rotation * -1.0).y > 0.0:
		brake_vector.y = STRAFE_THRUST * -1.0
	
	# Forward/reverse braking
	if ship_vector.rotated(rotation * -1.0).x > 0.0:
		brake_vector.x = REVERSE_THRUST * -1.0
	elif ship_vector.rotated(rotation * -1.0).x < 0.0:
		brake_vector.x = FORWARD_THRUST
	
	ship_vector += brake_vector.rotated(rotation)
	velocity = ship_vector * delta
	# Hard stop
	if (abs(velocity.x) < 1.0):
		velocity.x = 0.0
		ship_vector.x = 0.0
	if (abs(velocity.y) < 1.0):
		velocity.y = 0.0
		ship_vector.y = 0.0
	move_and_slide()

func _process(_delta: float) -> void:
	queue_redraw()

# TODO: In leu of a HUD, draw a velocity vector of the player ship.
func _draw() -> void:
	if OS.is_debug_build():
		
		# TODO: Unecessary to calculate rotation b/c line is a child of Ship.
		#         However, when moving this functionality to a HUD, this might
		#         be useful so I'm leaving it here for now.
		#var target_vector = Vector2(
			#DEBUG_SHIP_DIRECTION_LINE_MAGNITUDE * cos(rotation),
			#DEBUG_SHIP_DIRECTION_LINE_MAGNITUDE * sin(rotation)
		#)
		
		# Draws a straight out line
		var target_vector_forward = Vector2(DEBUG_SHIP_DIRECTION_LINE_MAGNITUDE, 0.0)
		draw_line(position.normalized(), position.normalized() + target_vector_forward, Color.GREEN, 4.0)
		var target_vector_lateral = Vector2(0.0, DEBUG_SHIP_DIRECTION_LINE_MAGNITUDE/2)
		draw_line(position.normalized(), position.normalized() + target_vector_lateral, Color.GREEN, 4.0)
