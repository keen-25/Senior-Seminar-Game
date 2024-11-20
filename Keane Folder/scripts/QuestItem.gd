#Questitem
extends Area2D

var player_in_area=false

@export var item: InventoryItem

var player =null

@onready var npc = get_tree().root.get_node("gamelevel/SpawnedNPC/NPCTRYAIAN")

func _process(delta: float) -> void:
	if player_in_area:
		if Input.is_action_just_pressed("interact")	:
			player.collect(item)
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area =true
		player =body
		print("Quest item obtained!")
		get_tree().queue_delete(self)
		npc.quest_complete = true

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false
		player=null
