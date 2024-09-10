extends Control


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/gamelevel.tscn")
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
