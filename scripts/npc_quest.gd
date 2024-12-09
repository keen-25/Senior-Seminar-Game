extends Control

signal quest_menu_closed

var quest1_active = false
var quest1_completed = false
var food = false

func _process(delta: float) -> void:
	if quest1_active:
		if food == true:
			print("Quest 1 Complete")
			quest1_active = false
			quest1_completed = true
			play_finish_quest()
	#if quest2_active:

func quest1_chat(npc_name):
	if npc_name == 'Rose':
		$quest1_ui.visible = true
	else:
		$no_quest.visible = true
		await get_tree().create_timer(3).timeout
		$no_quest.visible = false
	

func next_quest(npc_name):
	if !quest1_completed:
		quest1_chat(npc_name)
	else:
		$no_quest.visible = true
		await get_tree().create_timer(3).timeout
		$no_quest.visible = false
	#elif !quest2_completed:
		#quest2_chat()

func _on_yes_1_pressed() -> void:
	$quest1_ui.visible = false
	quest1_active = true
	#food = false
	emit_signal("quest_menu_closed")
	


func _on_no_1_pressed() -> void:
	$quest1_ui.visible = false
	quest1_active = false
	emit_signal("quest_menu_closed")

func food_collected():
	food = true

func play_finish_quest():
	$complete.visible = true
	await get_tree().create_timer(3).timeout
	$complete.visible = false
