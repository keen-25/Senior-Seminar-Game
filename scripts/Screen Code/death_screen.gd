class_name DeathMethod
extends Control

@export var game_manager: GameManager  # Ensure this is set

@export var start_level: PackedScene = preload("res://Screens/Game Level/gamelevel_New.tscn")  # Retry level

@onready var panel: Panel = $Panel
@onready var retry: Button = $Panel/VBoxContainer/retry
@onready var exit: Button = $Panel/VBoxContainer/exit

func _ready():
	# Dynamically find the game manager if not set
	if not game_manager:
		game_manager = get_tree().root.get_node("MainScene/GameManager")  # Adjust path
	if game_manager:
		print("GameManager found:", game_manager)
		game_manager.connect("killzone_triggered",_on_killzone_triggered)
		#game_manager.connect("toggle_game_paused",_on_game_manager_toggle_game_paused)
	else:
		print("Error: GameManager not set or not found!")
	handle_connecting_signals()
	hide()

func handle_connecting_signals() -> void:
	retry.pressed.connect(_on_retry_pressed)  # Retry button
	exit.pressed.connect(_on_exit_pressed)  # Exit button
	print("All signals connected!")

func _on_killzone_triggered(body):
	print("Killzone triggered by:", body.name)
	show()  # Display the death screen
	if game_manager:
		game_manager.game_paused = true  # Pause the game if a killzone is triggered

func _on_game_manager_toggle_game_paused(is_paused: bool):
	if is_paused:
		print("Game paused. Showing death screen.")
		show()
	else:
		print("Game resumed. Hiding death screen.")
		hide()

func _on_exit_pressed() -> void:
	print("Exiting game...")
	get_tree().quit()  # Quit the game

func _on_retry_pressed() -> void:
	print("Retrying level...")
	hide()  # Hide the death screen before retrying
	if game_manager:
		game_manager.game_paused = false  # Resume the game
	get_tree().change_scene_to_packed(start_level)  # Reload the level
