extends Button

@onready var background_sprite: Sprite2D = $background
@onready var item_stack_ui: ItemStackUI = $CenterContainer/Panel

func update_to_slot(slot: InventorySlot) -> void:
	if !slot.item:
		item_stack_ui.visible =false
		background_sprite.frame =0
		return
		
	item_stack_ui.inventorySlot = slot
	item_stack_ui.update()
	item_stack_ui.visible = true
	
	background_sprite.frame =1
	
