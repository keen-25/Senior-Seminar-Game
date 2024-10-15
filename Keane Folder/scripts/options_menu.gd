class_name OptionsMenu
extends Control

@export var Main = preload("res://Title_Screen/main_menu.tscn") as PackedScene
@onready var back_button: Button = $MarginContainer/VBoxContainer/Back_Button as Button


signal exit_options_menu
# Called when the node enters the scene tree for the first time.
func _ready():
	handle_connecting_signals()
	set_process(false)
	
func on_back_down() -> void:
	print("Pressed")
	exit_options_menu.emit()
	set_process(false)
	#get_tree().change_scene_to_packed(Main)

func handle_connecting_signals() -> void:
	back_button.button_down.connect(on_back_down)
