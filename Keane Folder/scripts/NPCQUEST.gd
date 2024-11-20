extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var move_speed: float = 30
@export var starting_direction: Vector2 = Vector2(0, 1)
var move_direction = Vector2(0, 1)  # Set the initial move direction
var change_direction_interval = 5.0  # Time interval to change direction (in seconds)
var time_elapsed = 0.0

var trial: Array = ["Y","N"]

# Reference to the Quest Manager
@onready var quest_manager = get_tree().get_root().get_node("QuestManager")

@export var npc_name: String
@export var assigned_quest: Resource  # Reference to a Quest resource
#@onready var dialog_popup = $"/root/DialogPopup"  # Adjust path to your dialog UI
@onready var dialog_popup = get_tree().root.get_node("DialogPopup")
var dialog_state = 0

func _ready() -> void:
	dialog_popup.connect("response_selected", Callable(self, "_on_dialog_response"))
	assigned_quest = quest_manager.get_quest_data(npc_name)
	if not assigned_quest:
		print("no quest assigned for NPC: %s" %npc_name)
		push_error("QuestManager is not loaded.")

# Start dialog by querying quest data
func start_dialog():
	print("we are here")
	if not assigned_quest:
		dialog_popup.show_dialog("I have nothing for you right now.", [])  # Retrieve quest resource from the QuestManager
		return
	
	print("we have something for you")
	match assigned_quest.quest_state:
		"Not Started":
			assigned_quest.dialog_state = 0
		"Started":
			assigned_quest.dialog_state = 1
		"Completed":
			assigned_quest.dialog_state = 2
			
	print(assigned_quest.quest_state)
	update_dialog()

# Update dialog based on quest data
func update_dialog():
	print("updating dialog")
	print("Quest Messages:", assigned_quest.quest_messages)
	print("Quest Responses:", assigned_quest.quest_responses)
	dialog_popup.show_dialog("hello", trial)
	var dialog = assigned_quest.quest_messages[assigned_quest.dialog_state]
	var responses = assigned_quest.quest_responses[assigned_quest.dialog_state]
	dialog_popup.show_dialog(dialog, responses)

# Update quest progress based on player response
func _on_dialog_response(option: String):
	match assigned_quest.dialog_state:
		0:
			if option == "Y":
				assigned_quest.quest_state = "Started"
				assigned_quest.dialog_state = 1
			elif option == "N":
				assigned_quest.quest_state = "Not Started"
				assigned_quest.dialog_state = 0
		1:
			if option == "Y":
				assigned_quest.quest_state = "Completed"
				assigned_quest.dialog_state = 2
			elif option == "N":
				assigned_quest.quest_state = "Started"
				assigned_quest.dialog_state = 1
	update_dialog()

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
