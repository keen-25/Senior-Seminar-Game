class_name MainMenu
extends Control

@export var start_level = preload("res://Screens/Game Level/gamelevel_New.tscn") as PackedScene
@export var Options = preload("res://Screens/Options:Settings Menu/options_menu.tscn") as PackedScene
@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/start_button as Button
@onready var settings_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/settings_button as Button
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/exit_button as Button
@onready var options_menu: OptionsMenu = $Options_Menu as OptionsMenu
@onready var margin_container = $MarginContainer as MarginContainer

func _ready():
	handle_connecting_signals()
	
func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
	
func on_set_down() -> void:
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true

func on_exit_down() -> void:
	get_tree().quit()
	
func on_exit_options_menu() -> void:
	margin_container.visible = true
	#options_menu.set_process(false)
	options_menu.visible = false

func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	settings_button.button_down.connect(on_set_down)
	exit_button.button_down.connect(on_exit_down)
	options_menu.exit_options_menu.connect(on_exit_options_menu)
