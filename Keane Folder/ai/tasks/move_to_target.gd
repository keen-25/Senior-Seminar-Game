extends BTAction

@export var target_var := &"target"

@export var speed_var = 60
@export var tolerance = 30

func _tick(_delta: float) -> Status:
	var target: CharacterBody2D = blackboard.get_var(target_var)
	if target != null:
		var target_position = target.global_position
		#need to make it so that the NPC and Enemy can move in the Y direction as well
		var dir = agent.global_position.direction_to(target_position) #only makes use of the x direction
		
		if abs(agent.global_position.x - target_position.x) < tolerance:
			agent.move(dir.x, 0)
			return SUCCESS
		else:
			#print(dir.x, " ", dir)
			agent.move(dir.x, speed_var) #need to add dir.y as well
			return RUNNING
			
	return FAILURE
