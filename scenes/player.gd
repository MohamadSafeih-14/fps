extends CharacterBody3D

var speed = 3
var gravity = 8
var mouse_sensitivity = 0.003
@onready var head = $Pivot
@onready var camera = $Pivot/Camera3D
var jump_impluse = 4.0
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if  is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = jump_impluse 
	if Input.is_action_just_pressed("jump"):
		speed = 10
	else:
		speed = 4
	if is_on_floor() and Input.is_action_just_pressed("shift"):
		rotate_x(-90)
		speed = 6
		get_tree().create_timer(1.1)
		speed = 3
		rotate_x(90)
	else:
		speed = 3
	var input = Input.get_vector("left", "right", "forward", "backward")
	var direction = (head.transform.basis * Vector3(input.x, 0, input.y)).normalized()
	

	if direction:
		velocity.z = direction.z * speed
		velocity.x = direction.x * speed
	else:
		velocity.z = 0
		velocity.x = 0
	print(direction)


	move_and_slide()
