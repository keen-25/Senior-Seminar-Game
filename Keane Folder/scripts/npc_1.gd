extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var move_speed : float = 100
@export var starting_direction: Vector2 = Vector2(0,1)


#func _ready() -> void:
	#update_animation_parameters(starting_direction)

func _physics_process(delta: float) -> void:
	var input_direction = Vector2(
		Input.get_action_strength('right') - Input.get_action_strength('left'),
		Input.get_action_strength('down') - Input.get_action_strength('up')
	)
	
	#print(input_direction)
	#update_animation_parameters(input_direction)
	
	#update velocity
	#velocity = input_direction * move_speed
	
	#move and slide function uses velocity of character body to move character on map
	#move(-1,50)
	move_and_slide()
	
	pick_new_state()
	
func update_animation_parameters(move_input : Vector2):
		#dont change if there is no move input
	if(move_input != Vector2.ZERO):
		pick_new_state()
		#animation_tree.set("parameters/walk/blend_position", move_input)
		#animation_tree.set("parameters/Idle/blend_position", move_input)
	
func pick_new_state():
	if(velocity != Vector2.ZERO):
		#state_machine.travel("walk")
		animated_sprite_2d.play('walk')
	else:
		#state_machine.travel("Idle")
		animated_sprite_2d.play('idle')

func move(dir, speed) -> void:
	velocity.x = dir * speed
	pick_new_state()
	update_flip(dir)

func update_flip(dir) -> void:
	if abs(dir) == dir:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true

func check_for_self(node):
	if node == self:
		return true
	else:
		return false
		
'''
func play_attack():
	animation_sprite.play("attack")
	await get_tree().create_timer(0.7).timeout
	$CPUParticle2D.emitting = true
	animation_sprite.visible = false
	await get_tree().create_timer(0.3).timeout
	self.queue_free()
'''
