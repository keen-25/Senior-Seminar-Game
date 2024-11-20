#extends Popup
extends CanvasLayer

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var player = $"../.."

var npc_name : set = npc_name_set
var message : set = message_set
var response : set = response_set

var npc
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func npc_name_set(new_value):
	npc_name = new_value
	$Dialog/NPC.text = new_value

	#sets the message with the value received from NPC
func message_set(new_value):
	message = new_value
	$Dialog/Message.text = new_value

	#sets the response with the value received from NPC
func response_set(new_value):
	response = new_value
	$Dialog/Response.text = new_value
	
func open():
	get_tree().paused = true
	self.visible = true
	animation_player.play("typewriter")
	player.set_physics_process(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

#closes the dialog  
func close():
	get_tree().paused = false
	self.visible = false
	player.set_physics_process(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_animation_tree_animation_finished(_anim_name: StringName) -> void:
	set_process_input(true) # Replace with function body.

func _input(event):
	if event is InputEventKey:
		if event.is_pressed():
			if event.keycode == KEY_Y:
				npc.dialog("Y")
			elif event.keycode == KEY_N:
				npc.dialog("N")
