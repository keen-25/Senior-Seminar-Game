extends Label


@onready var inventory: Inventory = preload("res://Jackson/Scenes/playerinv.tres")

var isOn=false
func _ready():
	off()

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("use_item"):
		var index = Global.hotbar_instance.current_selected
		if inventory.slots[index].item == null:
				return
		if inventory.slots[index].item.name == "note_collectible":
			set_text("8__")
			if isOn:
				off()
			else:
				on()
		if inventory.slots[index].item.name == "note2_collectible":
			set_text("_9_")
			if isOn:
				off()
			else:
				on()
		if inventory.slots[index].item.name == "note3_collectible":
			set_text("__2")
			if isOn:
				off()
			else:
				on()

func on():
	visible= true
	isOn =true
	 
func off():
	visible= false
	isOn =false
