extends CharacterBody3D

const SPEED = 30.0
const DECELERATION = 20.0
const ACCELERATION = 20.0

const JUMP_VELOCITY = 12.5

const SENSITIVITY = 0.002

const AIR_SPEED_MULTIPLIER = 2

var air_speed_modifier = 1

@onready var camera_arm: SpringArm3D = %CameraArm
@onready var camera: Camera3D = %Camera
@onready var mesh: MeshInstance3D = $MeshInstance3D

const BULLET_SCENE = preload("res://projectile/bullet.tscn")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * SENSITIVITY)
		camera_arm.rotate_x(-event.relative.y * SENSITIVITY)
		
		camera_arm.rotation_degrees = camera_arm.rotation_degrees.clampf(-80, 80)
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event.is_action_pressed("shoot"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		air_speed_modifier = AIR_SPEED_MULTIPLIER
	else:
		air_speed_modifier = 1
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED * air_speed_modifier, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED * air_speed_modifier, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
		velocity.z = move_toward(velocity.z, 0, DECELERATION * delta)
	
	if Input.is_action_just_pressed("shoot"):
		var bullet_inst: Area3D = BULLET_SCENE.instantiate()
		get_parent().add_child(bullet_inst)
		bullet_inst.global_rotation = camera.global_rotation
		bullet_inst.global_position = camera_arm.global_position
	
	mesh.global_rotation_degrees = Vector3(velocity.z * 2, 180, -velocity.x * 2)
	
	move_and_slide()
