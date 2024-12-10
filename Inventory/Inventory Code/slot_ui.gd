extends Button

#@onready var backgroundSprite: Sprite2D =$background
#@onready var container: CenterContainer = $CenterContainer
@onready var center_container: CenterContainer = $CenterContainer
@onready var background: Sprite2D = $background

@onready var inventory = preload("res://Inventory/Tres/playerinv.tres")

var itemStackUI: ItemStackUI
var index: int

func insert(isg: ItemStackUI):
	itemStackUI = isg
	background.frame = 1
	center_container.add_child(itemStackUI)
	
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
		center_container.remove_child(itemStackUI)
		itemStackUI= null
		
	background.frame=0
	
