#player

extends CharacterBody2D

@export var move_speed : float = 200
@export var starting_direction: Vector2 = Vector2(0,1)
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animated_sprite: Sprite2D = $Sprite2D
@onready var state_machine = animation_tree.get("parameters/playback")
#@onready var stamina_amount = $UI/StaminaAmount
@onready var staminabar: ColorRect = $UI/staminabar
@onready var ray_cast_2d: RayCast2D = $RayCast2D
#@export var interaction_distance: float = 50.0
#@onready var quest_manager = get_tree().get_root().get_node("QuestManager")

signal food_collected
signal hammer_collected
signal crowbar_collected

var in_locker=false

@export var inventory: Inventory

var stamina = 150
var max_stamina = 200
var regen_stamina = 5

signal stamina_updated

func _ready() -> void:
	update_animation_parameters(starting_direction)
	stamina_updated.connect(staminabar.update_stamina_ui)
	Global.set_hotbar($Hotbar)


func _physics_process(delta: float) -> void:
	var input_direction: Vector2
	input_direction.x=Input.get_action_strength('right') - Input.get_action_strength('left')
	input_direction.y=Input.get_action_strength('down') - Input.get_action_strength('up')
	
	# Normalize movement
	if abs(input_direction.x) == 1 and abs(input_direction.y) == 1:
		input_direction = input_direction.normalized()
	# Sprinting       		
	if Input.is_action_pressed("sprint"):
		if stamina >= 25:
			move_speed = 300
			stamina = stamina - 5
			stamina_updated.emit(stamina, max_stamina)
	elif Input.is_action_just_released("sprint"):
		move_speed = 200
	#print(input_direction)

	
	update_animation_parameters(input_direction)
	
	#update velocity
	velocity = input_direction * move_speed * delta
	
	if input_direction != Vector2.ZERO:
		ray_cast_2d.target_position = input_direction.normalized() * 50
	#move and slide function uses velocity of character body to move character on map
	#move and collide uses velocity as well
	if in_locker:
		velocity=Vector2.ZERO
		animated_sprite.visible=false
		set_collision_layer_value(6,true)
		set_collision_layer_value(1,false)
		set_collision_layer_value(2,false)
		set_collision_layer_value(2,false)
		if Input.is_action_just_pressed("interact"):
			animated_sprite.visible=true
			set_collision_layer_value(6,false)
			set_collision_layer_value(1,true)
			set_collision_layer_value(2,true)
			set_collision_layer_value(3,false)
			in_locker=false
			
	move_and_collide(velocity)
	#move_and_slide(velocity)
		
	pick_new_state()
	
func update_animation_parameters(move_input : Vector2):
		#dont change if there is no move input
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)
		
func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("walk")
	else:
		state_machine.travel("Idle")

func _process(delta):
	#regenerates stamina   
	var updated_stamina = min(stamina + regen_stamina * delta, max_stamina)
	if updated_stamina != stamina:
		stamina = updated_stamina
		stamina_updated.emit(stamina, max_stamina)


func collect(item):
	inventory.insert(item)
	print(item)
	if str(item) == "<Resource#-9223371992462260730>": #"apple"
		print("picked up food")
		emit_signal("food_collected")
	if str(item) == "<Resource>": #"note"
		print("picked up food")
		emit_signal("note_collected")
	if str(item) == "<Resource#-9223371990918756800>": #"crowbar"
		print("picked up crowbar")
		emit_signal("crowbar_collected")
	if str(item) == "<Resource#-9223371991774394823>": #"hammer"
		print("picked up hammer")
		emit_signal("hammer_collected")
	
func player():
	pass
