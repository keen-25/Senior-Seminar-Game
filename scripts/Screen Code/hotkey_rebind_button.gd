class_name HotKeyRebindButton
extends Control

@onready var label: Label = $HBoxContainer/Label as Label
@onready var button: Button = $HBoxContainer/Button as Button

@export var action_name: String = "left"

func _ready():
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()

# Updates the label based on the action_name value
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

# Updates the button text to show the currently bound key
'''
func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	if action_events.size() > 0:
		var action_event = action_events[0]
		var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
		button.text = "%s" % action_keycode
		print(action_keycode)
	else:
		button.text = "No key assigned"
'''

'''
func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	var action_event = action_events[0]
	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	
	button.text = "%s" % action_keycode

'''

func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	if action_events.size() > 0:  # Check if the array is not empty
		var action_event = action_events[0]
		var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
		button.text = "%s" % action_keycode
	else:
		button.text = "Unassigned"  # Fallback text if no key is assigned


'''
func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	var action_event = action_events[0]
	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	button.text = "%s" % action_keycode
'''


"""
# Handles when the button is toggled to capture new input
func _on_button_toggled(button_pressed) -> void:
	if button_pressed:
		button.text = "Press any key..."
		set_process_unhandled_input(true)  # Start processing input for rebind

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
"""


func _on_button_toggled(button_pressed) -> void:
	var rebind_buttons: Array[HotKeyRebindButton] = []
	rebind_buttons.append_array(get_tree().get_nodes_in_group("hotkey_button"))
	
	if button_pressed:  # This button is toggled on
		button.text = "Press any key..."
		set_process_unhandled_key_input(true)  # Enable input handling for rebinding
		
		# Disable toggling for all other buttons
		for rebind_button in rebind_buttons:
			if rebind_button != self:
				rebind_button.button.toggle_mode = false  # Disable toggle mode
				rebind_button.button.release()  # Ensure the button is not pressed
				rebind_button.set_process_unhandled_key_input(false)
	else:  # This button is toggled off
		set_process_unhandled_key_input(false)  # Stop handling input for rebinding
		set_text_for_key()  # Reset the button text



# Handles unhandled key inputs to rebind the action
func _unhandle_key_input(event):
	rebind_action_key(event)
	button.button_pressed = false

'''
# Rebinds the action to a new key
func rebind_action_key(event):
	var is_duplicate = false
	var action_keycode = OS.get_keycode_string(event.physical_keycode)
	
	for i in get_tree().get_nodes_in_group("hotkey_button"):
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
'''

"""
func rebind_action_key(event):
	var is_duplicate=false
	var action_event=event
	var action_keycode=OS.get_keycode_string(action_event.physical_keycode)
	for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name!=self.action_name:
				if i.button.text=="%s" %action_keycode:
					is_duplicate=true
					break
	if not is_duplicate:
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name,event)
		set_process_unhandled_key_input(false)
		set_text_for_key()
		set_action_name()
"""

func rebind_action_key(event) -> void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	
	set_process_unhandled_key_input(false)
	set_text_for_key()
	set_action_name()
#needed to make a change so here it is
#another change
