extends BTAction

@export var position_var: StringName = &"pos"  # Variable for the position to move to
@export var speed_var: float = 100  # Movement speed
@export var tolerance: float = 10  # Distance tolerance to stop moving

func _tick(_delta: float) -> Status:
	# Retrieve the target position from the blackboard
	var target_pos: Vector2 = blackboard.get_var(position_var, Vector2.ZERO)
	
	# Calculate direction from the agent's position to the target position
	var direction = agent.global_position.direction_to(target_pos)

	# Check if the agent is within tolerance range for both x and y directions
	if agent.global_position.distance_to(target_pos) < tolerance:
		# Stop moving when within tolerance
		agent.move_direction = Vector2.ZERO
		return SUCCESS
	else:
		# Move agent towards target position
		agent.move_direction = direction.normalized() * speed_var * _delta
		return RUNNING
