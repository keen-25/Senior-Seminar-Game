extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@export var inventory: Inventory

#@onready var locker = preload("res://scenes/locker.tscn")

func _ready():  
	Global.set_hotbar($Hotbar)
  

@onready var animated_sprite = $AnimatedSprite2D


var in_locker=false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	#gives input direction
	
	#flips sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction <0:
		animated_sprite.flip_h =true
		
	#play animation
	if is_on_floor():
		if direction ==0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
		
	
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	

	
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
			
			
		
	
	move_and_slide()
			
func player():
	pass
	
func collect(item):
	inventory.insert(item)
	
