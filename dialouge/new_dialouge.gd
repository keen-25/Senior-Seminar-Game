extends Control

@export_file("*.json") var d_file

signal dialouge_finished

var dialouge = []
var current_dialouge_id = 0
var d_active = false


func _ready() -> void:
	$NinePatchRect.visible = false
	
func start(npc_name):
	current_dialouge_id = 0
	if d_active:
		return
	d_active = true
	$NinePatchRect.visible = true
	dialouge = load_dialouge(npc_name)
	current_dialouge_id = -1
	next_script()
	
func load_dialouge(npc_name):
	if npc_name == 'Roger':
		var file = FileAccess.open("res://dialouge/rogerdialouge.json", FileAccess.READ)
		var content = JSON.parse_string(file.get_as_text())
		return content
	elif npc_name == 'Rose':
		var file = FileAccess.open("res://dialouge/rosedialouge.json", FileAccess.READ)
		var content =JSON.parse_string(file.get_as_text())
		return content
	else:
		var file = FileAccess.open("res://dialouge/nodia.json", FileAccess.READ)
		var content =JSON.parse_string(file.get_as_text())
		return content 
		
func _input(event):
	if !d_active:
		return
	if event.is_action_pressed("ui_accept"):
		next_script()
	
	
func next_script():
	current_dialouge_id += 1
	if current_dialouge_id >= len(dialouge):
		d_active = false
		$NinePatchRect.visible = false
		emit_signal("dialouge_finished")
		return
		
	$NinePatchRect/name.text = dialouge[current_dialouge_id]["name"]
	$NinePatchRect/text.text = dialouge[current_dialouge_id]["text"]
