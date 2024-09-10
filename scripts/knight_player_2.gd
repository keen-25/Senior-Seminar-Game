extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction: Vector2 = Vector2(0,1)
@onready var animation_tree: AnimationTree = $AnimationTree

func _ready() -> void:
	animation_tree.set(starting_direction)

func _physics_process(delta: float) -> void:
	var input_direction = Vector2(
		Input.get_action_strength('right') - Input.get_action_strength('left'),
		Input.get_action_strength('down') - Input.get_action_strength('up')
	)
	
	print(input_direction)
	
	#update velocity
	velocity = input_direction * move_speed
	
	#move and slide function uses velocity of character body to move character on map
	move_and_slide()
	
	func update_animation_parameters(move_input : Vector2):
		if(move_input != Vector2.ZERO):
			animation_tree.set("parameters/walk/blend_position", move_input)
			animation_tree.set("parameters/Idle/blend_position", move_input)
