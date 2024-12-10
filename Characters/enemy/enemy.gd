extends CharacterBody2D

const speed = 80
var current_state = IDLE

var dir = Vector2.RIGHT
var start_pos

var is_roaming = true
var player_chase = false
var player = null

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready() -> void:
	randomize()
	start_pos = position
	$Timer.start()  # Ensure the roaming timer is active

func _process(delta: float) -> void:
	# Handle animations based on states
	if current_state == IDLE or current_state == NEW_DIR:
		$AnimatedSprite2D.play("idle")
	elif current_state == MOVE and !player_chase:
		if dir.x == -1:
			$AnimatedSprite2D.play("move_left")
		elif dir.x == 1:
			$AnimatedSprite2D.play("move_right")
		elif dir.y == -1:
			$AnimatedSprite2D.play("move_up")
		elif dir.y == 1:
			$AnimatedSprite2D.play("move_down")
	
	# Roaming or chasing behavior
	if is_roaming and !player_chase:
		match current_state:
			IDLE:
				pass  # Idle state: do nothing
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
				current_state = MOVE  # Transition to move state
			MOVE:
				move(delta)

	if player_chase and player:
		chase_player(delta)

func chase_player(delta: float) -> void:
	# Chase the player
	velocity = (player.position - position).normalized() * speed
	move_and_slide()

	# Handle animations during chase
	if (player.position - position).x < 0:
		$AnimatedSprite2D.play("move_left")
	else:
		$AnimatedSprite2D.play("move_right")

func choose(array):
	array.shuffle()
	return array.front()

func move(delta: float) -> void:
	# Move in the current direction
	velocity = dir * speed
	move_and_slide()

func _on_detection_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_chase = true
		is_roaming = false

func _on_detection_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player = null
		player_chase = false
		is_roaming = true

func _on_timer_timeout() -> void:
	# Randomize the next state and timer duration
	$Timer.wait_time = choose([0.5, 1, 1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])
