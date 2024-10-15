extends BTAction

@export var group: StringName
@export var target_var: StringName = &"target"

var target

func _tick(_delta: float) -> Status:
	if group == "NPC":
		target = get_NPC_node()
		print(agent, " has found ", target)
	elif group == "player":
		target = get_player_node()
		print(agent, " has found ", target)
	print(target)
	blackboard.set_var(target_var, target)
	return SUCCESS
	
#used to allow the npc to follow each other and walk toward each other
#this will be on a probobility timer so that it doesnt happen all the time
#can also just use the code and change the group to move to other groups
#mayebe only good for the enemy
func get_NPC_node():
	var nodes: Array[Node] = agent.get_tree().get_nodes_in_group(group)
	if nodes.size() >= 2:
		while agent.check_for_self(nodes.front()):
			nodes.shuffle()
		return nodes.front()

func get_player_node():
	var nodes: Array[Node] = agent.get_tree().get_nodes_in_group(group)
	return nodes[0]
