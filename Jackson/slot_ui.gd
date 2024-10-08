extends Button

@onready var backgroundSprite: Sprite2D =$background
@onready var container: CenterContainer = $CenterContainer

@onready var inventory = preload("res://inventory/playerinv.tres")

var itemStackUI: ItemStackUI
var index: int

func insert(isg: ItemStackUI):
	itemStackUI = isg
	backgroundSprite.frame = 1
	container.add_child(itemStackUI)
	
	if !itemStackUI.inventorySlot || inventory.slots[index] == itemStackUI.inventorySlot: 
		return
	
	
	inventory.insertSlot(index, itemStackUI.inventorySlot)
	
func takeItem():
	var item = itemStackUI
	
	inventory.removeSlot(itemStackUI.inventorySlot)
	
	return item
	
func isEmpty():
	return !itemStackUI
	
	
func clear() -> void:
	if itemStackUI:
		container.remove_child(itemStackUI)
		itemStackUI= null
		
	backgroundSprite.frame=0
	
