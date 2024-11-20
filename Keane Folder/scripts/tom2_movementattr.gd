#player

extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction: Vector2 = Vector2(0,1)
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
#@onready var stamina_amount = $UI/StaminaAmount
@onready var staminabar: ColorRect = $UI/staminabar
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@export var interaction_distance: float = 50.0
@onready var quest_manager = get_tree().get_root().get_node("QuestManager")

@export var inventory: Inventory

var stamina = 100
var max_stamina = 150
var regen_stamina = 10

signal stamina_updated

func _ready() -> void:
	update_animation_parameters(starting_direction)
	stamina_updated.connect(staminabar.update_stamina_ui)
	Global.set_hotbar($Panel)


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
			move_speed = 150
			stamina = stamina - 5
			stamina_updated.emit(stamina, max_stamina)
	elif Input.is_action_just_released("sprint"):
		move_speed = 100
	#print(input_direction)

	
	update_animation_parameters(input_direction)
	
	#update velocity
	velocity = input_direction * move_speed * delta
	
	if input_direction != Vector2.ZERO:
		ray_cast_2d.target_position = input_direction.normalized() * 50
	#move and slide function uses velocity of character body to move character on map
	#move and collide uses velocity as well
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

func _input(event):
	if event.is_action_pressed("interact"):
		print("action pressed")
		interact_with_npc()
	#if event.is_action_pressed("interact"):
		#var target = ray_cast_2d.get_collider()
		#if target != null:
			#if target.is_in_group("NPC"):
				#target.dialog()
				#return
				# Talk to NPC
				#todo: add dialog function to npc

func collect(item):
	inventory.insert(item)
	
func player():
	pass

func interact_with_npc():
	var npc = get_nearest_npc()
	print("interacting with the NPC")
	if npc and npc.has_method("start_dialog"):
		print("start the dialog")
		npc.start_dialog()
			
func complete_quest(npc_name: String):
	quest_manager.update_quest_state(npc_name, "Completed")
	
func get_nearest_npc() -> Node:
	var npc_in_range = []
	for node in get_tree().get_nodes_in_group("NPC"):
		if global_position.distance_to(node.global_position) <= interaction_distance:
			npc_in_range.append(node)
	if npc_in_range.size() > 0:
		print("found the NPC")
		return npc_in_range[0]
	return null
