extends Area2D

var player_in_area=false

var player =null

var is_lock=false


func _process(delta: float) -> void:
	if player_in_area:
		if Input.is_action_just_pressed("interact")	:
			if is_lock:
				exit()
			else:
				hidden()
				is_lock=false

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area =true
		player =body


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false
		player=null
		
func hidden():
	is_lock =true
	player.in_locker=true
	
func exit():
	player.in_locker=false
		
