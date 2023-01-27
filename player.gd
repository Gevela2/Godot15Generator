extends CharacterBody3D


var SPEED
var walk_speed = 5
var run = 10
const JUMP_VELOCITY = 4.5
const ACCEL_DEFAULT = 0.1
const ACCEL_AIR = 0.25
var mouse_sense = 0.05
@onready var accel = ACCEL_DEFAULT
var fric = 0.1

@onready var head =$Head
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))


func _physics_process(delta):
	# Add the gravity.
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		accel = ACCEL_AIR
	else:
		accel = ACCEL_DEFAULT

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("Sprint"):
		SPEED = run
	else:
		SPEED = walk_speed
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x,direction.x * SPEED,accel)
		velocity.z = lerp(velocity.z,direction.z * SPEED,accel)
	else:
		velocity.x = lerp(velocity.x, 0.0, fric)
		velocity.z = lerp(velocity.z, 0.0, fric)

	move_and_slide()
