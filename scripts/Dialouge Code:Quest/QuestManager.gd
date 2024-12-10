# QuestManager.gd
extends Node

var active_quests: Dictionary = {}  # Store quests by NPC name

func _ready():
	print(active_quests)
	var chef_quest = preload("res://Quest/exampleQuest.tres")
	add_quest("Chef NPC", chef_quest)
	print(active_quests)

# Add a quest to the active list
func add_quest(npc_name: String, quest_resource: Resource):
	active_quests[npc_name] = quest_resource

# Get quest data for a specific NPC
func get_quest_data(npc_name: String) -> Resource:
	return active_quests.get(npc_name, null)

# Update quest state
func update_quest_state(npc_name: String, quest_state: String):
	if npc_name in active_quests:
		active_quests[npc_name].quest_state = quest_state
