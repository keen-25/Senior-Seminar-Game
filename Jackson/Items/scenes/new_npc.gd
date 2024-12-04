extends CharacterBody2D

const speed = 30
var current_state = SIDE_LEFT

var dir = Vector2.RIGHT
var start_pos

var is_roaming = true
var is_chatting = false

var player
var player_in_chat_zone = false

@export var npc_name: String

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready() -> void:
	randomize()
	start_pos = position

func _process(delta: float) -> void:
	if current_state == 0 or current_state == 1:
		$AnimatedSprite2D.play("idle_down")
	elif current_state == 2 and !is_chatting:
		if dir.x == -1:
			$AnimatedSprite2D.play("walk_w")
		if dir.x == 1:
			$AnimatedSprite2D.play("walk_e")
		if dir.y == -1:
			$AnimatedSprite2D.play("walk_n")
		if dir.y == 1:
			$AnimatedSprite2D.play("walk_s")
			
	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
			MOVE:
				move(delta)
				
	if Input.is_action_just_pressed("chat"):
		print("chatting with npc")
		if player_in_chat_zone == true:
			$Dialouge.start(npc_name)
			is_roaming = false
			is_chatting = true
			$AnimatedSprite2D.play("idle_down")
	if Input.is_action_just_pressed("quest"):
		print("Quest with npc")
		if player_in_chat_zone == true:
			$npc_quest.next_quest(npc_name)
			is_roaming = false
			is_chatting = true
			$AnimatedSprite2D.play("idle_down")
				
func choose(array):
	array.shuffle()
	return array.front()

func move(delta):
	if !is_chatting:
		velocity = dir * speed
		move_and_slide()



func _on_chat_detection_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_in_chat_zone = true
	



func _on_chat_detection_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_chat_zone = false


func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([0.5,1,1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])


func _on_dialouge_dialouge_finished() -> void:
	is_chatting = false
	is_roaming = true


func _on_npc_quest_quest_menu_closed() -> void:
	is_chatting = false
	is_roaming = true
	

func _on_player_tom_food_collected() -> void:
	$npc_quest.food_collected()
