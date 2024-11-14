extends Area2D

@onready var keypad = $Keypad

var player_in_area=false

var player =null

var key_open=false

func _ready() -> void:
	close()
	keypad.delete.connect(delete)

func _process(delta: float) -> void:
	if player_in_area:
		if Input.is_action_just_pressed("e")	:
			if key_open:
				close()
			else:
				open()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true
		player=body
		
func _on_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area =false
		player =null

func open():
	key_open=true
	keypad.visible=true
	
	
func close():
	key_open=false
	keypad.visible=false

func delete():
	queue_free()
