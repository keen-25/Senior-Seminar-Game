extends PointLight2D


@onready var inventory: Inventory = preload("res://Jackson/Scenes/playerinv.tres")

var isOn=false

func _ready():
	off()

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("use_item"):
		var index = Global.hotbar_instance.current_selected
		if inventory.slots[index].item == null:
				return
		if inventory.slots[index].item.name == "flashlight_collectible":
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
