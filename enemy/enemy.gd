extends CharacterBody2D

var speed = 60
var player_chase = false
var player = null

#signal killzone_triggered

func _physics_process(delta: float) -> void:
	if player_chase:
		position += (player.position - position)/speed
		
		if (player.position.x - position.x)<0:
			$AnimatedSprite2D.play("move_left")
		else:
			$AnimatedSprite2D.play("move_right")
	else:
		$AnimatedSprite2D.play("idle")

func _on_detection_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player=body
		player_chase = true
		if player.in_locker == true:
			player_chase = false


func _on_detection_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player = null
		player_chase = false
	
