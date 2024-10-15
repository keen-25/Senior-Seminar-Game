extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -200.0

var gravity = ProjectSettings.get_setting('physics/2d/default_gravity')
var direction: Vector2 = Vector2()

@onready var sprite_2d: Sprite2D = $Sprite2D

func read_input() -> Vector2:
	var input_direction = Vector2.ZERO

	if Input.is_action_pressed("up"):
		input_direction.y -= 1
	if Input.is_action_pressed("down"):
		input_direction.y += 1
	if Input.is_action_pressed("left"):
		input_direction.x -= 1
	if Input.is_action_pressed("right"):
		input_direction.x += 1

	return input_direction.normalized()

func _physics_process(delta: float) -> void:
	# Read input and update direction
	direction = read_input()

	# Update velocity based on direction and speed
	velocity.x = direction.x * SPEED
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Move the character using velocity
	move_and_slide()

	# Update sprite flipping and animation
	update_sprite()

func update_sprite() -> void:
	# Flip sprite based on direction
	if direction.x > 0:
		sprite_2d.flip_h = false
	elif direction.x < 0:
		sprite_2d.flip_h = true

	# Play animation based on movement state
	if is_on_floor():
		if direction == Vector2.ZERO:
			sprite_2d.play("idle")
		else:
			sprite_2d.play("run")
	else:
		sprite_2d.play("jump")
		
