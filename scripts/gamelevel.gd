class_name GameManager
extends Node2D

# Signals
signal toggle_game_paused(is_paused: bool)
signal killzone_triggered(body: Node)  # Include the body for more context

# Game pause state
var game_paused: bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused  # Pause/unpause the game tree
		emit_signal("toggle_game_paused", game_paused)  # Notify listeners

# Handle input for toggling pause
func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):  # For example, "Esc" key
		game_paused = !game_paused

# Emit the killzone signal (e.g., triggered by enemies)
func trigger_killzone(body: Node):
	print("Killzone triggered by:", body.name)
	emit_signal("killzone_triggered", body)
	game_paused = true  # Automatically pause the game when killzone is triggered

		
