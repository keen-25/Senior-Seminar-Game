class_name In_Game_Menu
extends Control

@export var Options = preload("res://Screens/Options:Settings Menu/options_menu.tscn") as PackedScene

@export var game_manager : GameManager

@export var save_manager_script = preload("res://autoloads/SaveManager.gd")

@onready var settings_button: Button = $Panel/VBoxContainer/settings

@onready var options_menu: OptionsMenu = $Options_Menu

@onready var load: Button = $Panel/VBoxContainer/load

@onready var save: Button = $Panel/VBoxContainer/save

@onready var panel: Panel = $Panel

var save_manager: Object = null

func _ready():
	# Debugging initialization
	if not save_manager:
		save_manager = save_manager_script.new()
	
	handle_connecting_signals()
	hide()
	game_manager.connect("toggle_game_paused", _on_game_manager_toggle_game_paused)

func _on_game_manager_toggle_game_paused(is_paused : bool):
	if(is_paused):
		show()
	else:
		hide()


func on_exit_options_menu() -> void:
	print("Exiting options menu...")
	panel.visible = true
	options_menu.visible = false

func handle_connecting_signals() -> void:
	#resume_button.pressed.connect(_on_resume_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	#exit_button.pressed.connect(_on_exit_pressed)
	save.pressed.connect(_on_save_pressed)
	load.pressed.connect(_on_load_pressed)
	options_menu.exit_options_menu.connect(on_exit_options_menu)
	print("All signals connected!")

func _on_resume_pressed() -> void:
	print("Resuming game...")
	game_manager.game_paused = false
	#margin_container.visible = false
	#gamelevel.set_process(true)
	#game_manager.visible = true


func _on_exit_pressed() -> void:
	print("Exiting game...")
	get_tree().quit()


func _on_settings_pressed() -> void:
	print("Opening settings menu...")
	panel.visible = false
	options_menu.set_process(true)
	options_menu.visible = true


func _on_save_pressed() -> void:
	if save_manager:
		save_manager.on_settings_save(save_manager.settings_data_dict)
		print("Game settings saved!")
	else:
		print("Error: SaveManager not found!") # Replace with function body.


func _on_load_pressed() -> void:
	if save_manager:
		save_manager.load_settings_data()
		print("Game settings loaded!")
	else:
		print("Error: SaveManager not found!") # Replace with function body.
