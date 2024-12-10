#NPC_1
extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var move_speed : float = 100
@export var starting_direction: Vector2 = Vector2(0,1)

@onready var dialog_popup = get_tree().root.get_node("Characters/tom_player/UI/DialogPopup")
@onready var player = get_tree().root.get_node("Characters/tom_player")
@onready var animation_sprite = $AnimatedSprite2D

#quest and dialog states

enum QuestStatus { NOT_STARTED, STARTED, COMPLETED }
var quest_status = QuestStatus.NOT_STARTED
var dialog_state = 0
var quest_complete = false

#gets the NPC name
@export var npc_name = ""

func _ready() -> void:
	animated_sprite_2d.play('idle_down')
	#update_animation_parameters(starting_dire

# dialog tree
func dialog(response = ""):
	# Set our NPC's animation to "talk"
	animated_sprite_2d.play("talk_down")
	# Set dialog_popup npc to be referencing this npc
	dialog_popup.npc = self
	dialog_popup.npc_name = str(npc_name)
	# dialog tree
	match quest_status:
		QuestStatus.NOT_STARTED:
			match dialog_state:
				0:
					# Update dialog tree state
					dialog_state = 1
					# Show dialog popup
					dialog_popup.message = "Howdy Partner. I haven't seen anybody round these parts in quite a while. That reminds me, I recently lost my momma's secret recipe book, can you help me find it?"
					dialog_popup.response = "[Y] Yes  [N] No"
					dialog_popup.open() # re-open to show next dialog
				1:
					match response:
						"Y":
							# Update dialog tree state
							dialog_state = 2
							# Show dialog popup
							dialog_popup.message = "That's mighty kind of you, thanks."
							dialog_popup.response = "[Y] Bye"
							dialog_popup.open() # re-open to show next dialog
						"N":
							# Update dialog tree state
							dialog_state = 3
							# Show dialog popup
							dialog_popup.message = "Well, I'll be waiting like a tumbleweed 'till you come back."
							dialog_popup.response = "[Y] Bye"
							dialog_popup.open() # re-open to show next dialog
				2:
					# Update dialog tree state
					dialog_state = 0
					quest_status = QuestStatus.STARTED
					# Close dialog popup
					dialog_popup.close()
					# Set NPC's animation back to "idle"
					animated_sprite_2d.play("idle_down")
				3:
					# Update dialog tree state
					dialog_state = 0
					# Close dialog popup
					dialog_popup.close()
					# Set NPC's animation back to "idle"
					animated_sprite_2d.play("idle_down")
		QuestStatus.STARTED:
			match dialog_state:
				0:
					# Update dialog tree state
					dialog_state = 1
					# Show dialog popup
					dialog_popup.message = "Found that book yet?"
					if quest_complete:
						dialog_popup.response = "[Y] Yes  [N] No"
					else:
						dialog_popup.response = "[Y] No"
					dialog_popup.open()
				1:
					if quest_complete and response == "Y":
						# Update dialog tree state
						dialog_state = 2
						# Show dialog popup
						dialog_popup.message = "Yeehaw! Now I can make cat-eye soup. Here, take this."
						dialog_popup.response = "[Y] Bye"
						dialog_popup.open()
					else:
						# Update dialog tree state
						dialog_state = 3
						# Show dialog popup
						dialog_popup.message = "I'm so hungry, please hurry..."
						dialog_popup.response = "[Y] Bye"
						dialog_popup.open()
				2:
					# Update dialog tree state
					dialog_state = 0
					quest_status = QuestStatus.COMPLETED
					# Close dialog popup
					dialog_popup.close()
					# Set NPC's animation back to "idle"
					animated_sprite_2d.play("idle_down")
					# Add pickups and XP to the player.
					#player.add_pickup(Global.Pickups.AMMO)
					player.update_xp(50)
				3:
					# Update dialog tree state
					dialog_state = 0
					# Close dialog popup
					dialog_popup.close()
					# Set NPC's animation back to "idle"
					animated_sprite_2d.play("idle_down")
		QuestStatus.COMPLETED:
			match dialog_state:
				0:
					# Update dialog tree state
					dialog_state = 1
					# Show dialog popup
					dialog_popup.message = "Nice seeing you again partner!"
					dialog_popup.response = "[Y] Bye"
					dialog_popup.open()
				1:
					# Update dialog tree state
					dialog_state = 0
					# Close dialog popup
					dialog_popup.close()
					# Set NPC's animation back to "idle"
					animated_sprite_2d.play("idle_down")


func _physics_process(_delta: float) -> void:
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
