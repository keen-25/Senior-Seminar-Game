#item stack gd
extends Panel

class_name ItemStackUI

var inventorySlot: InventorySlot

@onready var itemSprite: Sprite2D = $item
@onready var amount: Label = $Label

func update():
	if !inventorySlot || !inventorySlot.item: return
	
	itemSprite.visible =true
	itemSprite.texture = inventorySlot.item.texture
	
	if inventorySlot.amount > 1:
		amount.visible =true
		amount.text = str(inventorySlot.amount)
	else:
		amount.visible =false
