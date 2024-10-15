class_name HotKeyRebindButton2
extends Control

@onready var label: Label = $HBoxContainer/Label as Label
@onready var button: Button = $HBoxContainer/Button as Button

@export var action_name: String = "left"

func _ready():
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()

func set_action_name() -> void:
	label.text = "Unassigned"

	match action_name:
		"left":
			label.text = "Move Left"
		"right":
			label.text = "Move Right"
		"jump":
			label.text = "Jump"
		"up":
			label.text = "Move Up"
		"down":
			label.text = "Move Down"
		"menu":
			label.text = "Menu"

func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	if action_events.size() > 0:
		var action_event = action_events[0]
		var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
		button.text = "%s" % action_keycode
		print(action_keycode)
	else:
		button.text = "Unassigned"

func _on_button_toggled(button_pressed) -> void:
	if button_pressed:
		button.text = "Press any key..."
		set_process_unhandled_input(button_pressed)

		for i in get_tree().get_nodes_in_group("hotkeybutton"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_unhandled_key_input(false)

	else:
		for i in get_tree().get_nodes_in_group("hotkeybutton"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = true
				i.set_process_unhandled_key_input(false)

		set_text_for_key()

func _unhandled_key_input(event):
	rebind_action_key(event)
	button.pressed = false

func rebind_action_key(event):
	var is_duplicate = false
	var action_keycode = OS.get_keycode_string(event.physical_keycode)  # Fix here, no reassignment to event
	
	for i in get_tree().get_nodes_in_group("hotkeybutton"):
		if i.action_name != self.action_name:
			if i.button.text == "%s" % action_keycode:
				is_duplicate = true
				self.button.text = "'" + action_keycode + "' already bound"
				await get_tree().create_timer(2.0).timeout
				set_process_unhandled_key_input(false)
				set_text_for_key()
				break

	if not is_duplicate:
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name, event)
		set_process_unhandled_key_input(false)
		set_text_for_key()
		set_action_name()
