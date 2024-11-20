#NPC_Movment and dialog
extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var move_speed: float = 30
@export var starting_direction: Vector2 = Vector2(0, 1)  # Define a starting movement direction
@onready var dialog_popup = get_tree().root.get_node("DialogPopup")
@onready var player = get_tree().root.get_node("Characters/tom_player")

# Quest and dialog states
enum QuestStatus { NOT_STARTED, STARTED, COMPLETED }
var quest_status = QuestStatus.NOT_STARTED
var dialog_state = 0
var quest_complete = false

# NPC name
@export var npc1_name = ""

# Automatic movement direction and state
var move_direction = Vector2(0, 1)  # Set the initial move direction
var change_direction_interval = 5.0  # Time interval to change direction (in seconds)
var time_elapsed = 0.0

func _ready() -> void:
	if dialog_popup == null:
		print('Not shit')
	else:
		animated_sprite_2d.play('idle_down')
		move_direction = starting_direction.normalized()  # Start with the specified starting direction

# dialog tree
func dialog(response = ""):
	# Set our NPC's animation to "talk"
	animated_sprite_2d.play("idle_down")
	# Set dialog_popup npc to be referencing this npc
	dialog_popup.npc1 = self
	dialog_popup.npc1_name = str(npc1_name)
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
					#player.update_xp(50)
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
	# Update velocity based on the current move direction
	velocity = move_direction * move_speed
	
	# Move the NPC automatically
	move_and_slide()

	# Update animation based on movement direction
	update_animation_parameters(move_direction)
	
	# Change direction at intervals
	time_elapsed += _delta
	if time_elapsed >= change_direction_interval:
		time_elapsed = 0
		change_direction()

func update_animation_parameters(move_input: Vector2) -> void:
	if move_input != Vector2.ZERO:
		# Change the animation based on movement direction
		if move_input.y > 0:
			animated_sprite_2d.play("walk_down")
		elif move_input.y < 0:
			animated_sprite_2d.play("walk_up")
		elif move_input.x > 0:
			animated_sprite_2d.play("walk_right")
		elif move_input.x < 0:
			animated_sprite_2d.play("walk_left")
	else:
		# Change to idle animation based on last movement direction
		if velocity.y > 0:
			animated_sprite_2d.play("idle_down")
		elif velocity.y < 0:
			animated_sprite_2d.play("idle_up")
		elif velocity.x > 0:
			animated_sprite_2d.play("idle_right")
		elif velocity.x < 0:
			animated_sprite_2d.play("idle_left")

# Function to change the NPC's movement direction randomly
func change_direction() -> void:
	# Randomly select a new direction (up, down, left, or right)
	var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
	move_direction = directions[randi() % directions.size()].normalized()

# Function to ensure the sprite flips if moving left or right
func update_flip(dir: float) -> void:
	if abs(dir) == dir:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true

func check_for_self(node):
	if node == self:
		return true
	else:
		return false


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.



func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
