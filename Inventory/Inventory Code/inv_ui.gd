extends Control

var isOpen = false

@onready var inventory: Inventory = preload("res://Inventory/Tres/playerinv.tres")
@onready var ItemStackUIClass = preload("res://Inventory/Inventory Scene/itemStackUI.tscn")
@onready var hotbar_slots: Array =$NinePatchRect/HBoxContainer.get_children()
@onready var slots: Array = hotbar_slots + $NinePatchRect/GridContainer.get_children()

var itemAtHand: ItemStackUI
var oldIndex: int = -1


func _ready():
	connectSlots()
	inventory.update.connect(update_slots)
	update_slots()
	close()
	

func connectSlots():
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i
		
		var callable = Callable(onSlotClicked)
		callable= callable.bind(slot)
		slot.pressed.connect(callable)

func update_slots():
	for i in range(min(inventory.slots.size(),slots.size())):
		var inventorySlot: InventorySlot = inventory.slots[i]
		
		if !inventorySlot.item:
			slots[i].clear()
			continue
		
		var itemStackUI: ItemStackUI = slots[i].itemStackUI
		if !itemStackUI:
			itemStackUI = ItemStackUIClass.instantiate()
			slots[i].insert(itemStackUI)
			
		itemStackUI.inventorySlot = inventorySlot
		itemStackUI.update()	



func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inv_ui"):
		if isOpen:
			close()
		else:
			open()


func open():
	visible= true
	isOpen =true
	
func close():
	visible= false
	isOpen =false
	
func onSlotClicked(slot):
	if slot.isEmpty():
		if !itemAtHand: return
		
		insertItemInSlot(slot)
		return 
	
	if !itemAtHand:	
		takeItemFromSlot(slot)
		return
	
	swapItems(slot)
	
func takeItemFromSlot(slot):	
	itemAtHand = slot.takeItem()
	add_child(itemAtHand)
	updateItemAtHand()
	
	oldIndex = slot.index
	
func insertItemInSlot(slot):
	var item = itemAtHand
	
	remove_child(itemAtHand)
	itemAtHand = null
	slot.insert(item)
	
	oldIndex = -1
	


func swapItems(slot):
	var tempItem = slot.takeItem()
	
	insertItemInSlot(slot)
	
	itemAtHand = tempItem
	add_child(itemAtHand)
	updateItemAtHand()
		
	
func updateItemAtHand():
	if !itemAtHand: return null
	itemAtHand.global_position = get_global_mouse_position() - itemAtHand.size / 2
	
func putItemBack():
	if oldIndex < 0:
		var emptySlots= slots.filter(func(s): return s.isEmpty())
		if emptySlots.is_empty(): return
		
		oldIndex = emptySlots[0].index
	
	var targetSlot = slots[oldIndex]
	insertItemInSlot(targetSlot)
	
func _input(_event):
	if itemAtHand && Input.is_action_just_pressed("right_click"):
		putItemBack()
	updateItemAtHand()
	
