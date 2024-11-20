# Quest.gd
extends Resource
@export var quest_id: String
@export var npc_name: String
@export var quest_state: String = "Not Started"  # "Not Started", "Started", "Completed"
@export var dialog_state: int = 0
@export var quest_messages: Array = []  # Array of dialog messages
@export var quest_responses: Array = []  # Array of dialog responses
