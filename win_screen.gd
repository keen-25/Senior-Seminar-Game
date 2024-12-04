extends CanvasLayer


func _on_back_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Title_Screen/main_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
