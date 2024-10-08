extends Resource


class_name Inventory

signal update

@export var slots: Array[InventorySlot]

func insert(item: InventoryItem):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount +=1
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].amount = 1
			emptyslots[0].item = item
	update.emit()		
		
func removeItemAtIndex(index: int):
	slots[index] = InventorySlot.new()
	update.emit()
	
func insertSlot(index: int, inventorySlot: InventorySlot):
	slots[index] = inventorySlot
	update.emit()
	

func removeSlot(inventorySlot: InventorySlot):
	var index = slots.find(inventorySlot)
	if index <0: return 
	
	remove_at_index(index)
	
	
func remove_at_index(index: int)->void:
	
	slots[index] = InventorySlot.new()
	update.emit()
	

#you can choose which items can't be deleted based on name
func use_item_at_index(index: int)-> void:
	if index <0 || index >= slots.size() || !slots[index].item || slots[index].item.name == "stick": return
	
	var slot = slots[index]
	
	if slot.amount>1:
		slot.amount -=1
		update.emit()
		return
	
	remove_at_index(index)
