extends Panel

class_name Hotbar

@onready var inventory: Inventory = preload("/Users/keanealbright/topdown-crashcourse/Jackson/Scenes/playerinv.tres")
@onready var slots: Array = $Container.get_children()
@onready var selector: Sprite2D = $Selector

var current_selected: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update()
	inventory.update.connect(update)

func update() -> void:
	for i in range(slots.size()):
		var inventory_slot: InventorySlot = inventory.slots[i]
		slots[i].update_to_slot(inventory_slot)
		
func move_selector() -> void:
	current_selected = (current_selected + 1) % slots.size()
	selector.global_position = slots[current_selected].global_position

		
func _unhandled_input(event) -> void:
	if event.is_action_pressed("interact"):
		inventory.use_item_at_index(current_selected)
	if event.is_action_pressed("move_selector"):
		move_selector()
