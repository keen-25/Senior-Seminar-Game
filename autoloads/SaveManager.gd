extends Node

const SETTINGS_SAVE_PATH : String = "user://SettingsDat.save"

var settings_data_dict : Dictionary = {}

func _ready():
	SettingsSignalBus.set_settings_dictionary.connect(on_settings_save)
	load_settings_data()
	
func on_settings_save(data:Dictionary) -> void:
	#settings_data_dict = data
	
	var save_settings_data_file = FileAccess.open_encrypted_with_pass(SETTINGS_SAVE_PATH, FileAccess.WRITE, "Keane")
	
	var json_data_string = JSON.stringify(data)
	
	save_settings_data_file.store_line(json_data_string)

func load_settings_data() -> void:
	if not FileAccess.file_exists(SETTINGS_SAVE_PATH):
		print("no save data")
		return
	
	var save_settings_data_file = FileAccess.open_encrypted_with_pass(SETTINGS_SAVE_PATH, FileAccess.READ, "Keane")
	#var loaded_data : Dictionary = {}
	
	while save_settings_data_file.get_position() < save_settings_data_file.get_length():
		var json_string = save_settings_data_file.get_line()
		var json = JSON.new()
		if json.parse(json_string) == OK: #this can be deleted if it doesnt work
			settings_data_dict = json.get_data()
		#var _parsed_result = json.parse(json_string)
		
		#loaded_data = json.get_data()
		#print(loaded_data)
		
	#SettingsSignalBus.emit_load_settings_data(loaded_data)
	SettingsSignalBus.emit_load_settings_data(settings_data_dict)