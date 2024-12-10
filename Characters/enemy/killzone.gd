extends Area2D

@onready var timer: Timer = $Timer  # Timer node reference

@onready var inventory: Inventory = preload("res://Inventory/Tres/playerinv.tres")

@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer" as AudioStreamPlayer



signal killzone_triggered  # Signal to notify when the killzone is triggered

func _ready():
	# Connect internal signals
	timer.connect("timeout", _on_timer_timeout)

# Trigger when a body enters the killzone
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Ensure the body is the player
		for i in range(0,12):
			inventory.remove_at_index(i)
			inventory.removeItemAtIndex(i)
		audio_stream_player.play()
		print("You died!")
		emit_signal("killzone_triggered", body)  # Notify listeners
		#audio_stream_player.play()
		Engine.time_scale = 0.5  # Slow down time for dramatic effect
		body.get_node("CollisionShape2D").queue_free()  # Remove player's collision
		audio_stream_player.play()
		get_tree().change_scene_to_file("res://Screens/In-game Screens/death_screen.tscn")
		timer.start()  # Start the delay timer

# Handle timer timeout to reset time and reload scene
func _on_timer_timeout() -> void:
	Engine.time_scale = 1  # Reset time scale
	get_tree().reload_current_scene()  # Reload the current scene
