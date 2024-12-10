extends Control

signal quest_menu_closed

var quest1_active = false
var quest1_completed = false
var quest2_active = false
var quest2_completed = false
var quest3_active = false
var quest3_completed = false

var food = false
var manuel = false
var rock = false

func _process(delta: float) -> void:
	if quest1_active:
		if food == true:
			print("Quest 1 Complete")
			quest1_active = false
			quest1_completed = true
			play_finish_quest()
	if quest2_active:
		if rock == true:
			print("Quest 2 Complete")
			quest2_active = false
			quest2_completed = true
			play_finish_quest()
	if quest3_active:
		if manuel == true:
			print("Quest 3 Complete")
			quest3_active = false
			quest3_completed = true
			play_finish_quest()
		
func quest1_chat(npc_name):
	if npc_name == 'Rose':
		$quest1_ui.visible = true
	else:
		$no_quest.visible = true
		await get_tree().create_timer(3).timeout
		$no_quest.visible = false

func quest_chat2(npc_name):
	if npc_name == 'Rick':
		$quest_ui2.visible = true
	else:
		$no_quest2.visible = true
		await get_tree().create_timer(3).timeout
		$no_quest2.visible = false

func quest_chat3(npc_name):
	if npc_name == 'Roger':
		$quest_ui3.visible = true
	else:
		$no_quest3.visible = true
		await get_tree().create_timer(3).timeout
		$no_quest3.visible = false

func next_quest(npc_name):
	if !quest1_completed:
		quest1_chat(npc_name)
	if !quest2_completed:
		quest_chat2(npc_name)
	if !quest3_completed:
		quest_chat3(npc_name)
	else:
		if npc_name == "Rose":
			$no_quest.visible = true
			await get_tree().create_timer(3).timeout
			$no_quest.visible = false
		if npc_name == "Rick":
			$no_quest2.visible = true
			await get_tree().create_timer(3).timeout
			$no_quest2.visible = false
		if npc_name == "Roger":
			$no_quest3.visible = true
			await get_tree().create_timer(3).timeout
			$no_quest3.visible = false
		
func _on_yes_1_pressed() -> void:
	$quest1_ui.visible = false
	quest1_active = true
	#food = false
	emit_signal("quest_menu_closed")

func _on_no_1_pressed() -> void:
	$quest1_ui.visible = false
	quest1_active = false
	emit_signal("quest_menu_closed")



func _on_yes_2_pressed() -> void:
	$quest_ui2.visible = false
	quest2_active = true
	#food = false
	emit_signal("quest_menu_closed")

func _on_no_2_pressed() -> void:
	$quest_ui2.visible = false
	quest2_active = false
	emit_signal("quest_menu_closed")
	
	
	
func _on_yes_3_pressed() -> void:
	$quest_ui3.visible = false
	quest1_active = true
	#food = false
	emit_signal("quest_menu_closed")
	
func _on_no_3_pressed() -> void:
	$quest_ui3.visible = false
	quest1_active = false
	emit_signal("quest_menu_closed")


func food_collected():
	food = true
	
func manuel_collected():
	manuel = true
	
func rock_collected():
	rock = true

func play_finish_quest():
	if food == true:
		$complete.visible = true
		await get_tree().create_timer(10).timeout
		$complete.visible = false
	if rock == true:
		$complete2.visible = true
		await get_tree().create_timer(10).timeout
		$complete2.visible = false
	if manuel == true:
		$complete3.visible = true
		await get_tree().create_timer(10).timeout
		$complete3.visible = false
