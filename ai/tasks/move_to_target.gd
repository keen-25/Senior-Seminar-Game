#move_to_target
extends BTAction

@export var target_var := &"target"  # Variable for the target position
@export var speed_var: float = 100  # Movement speed
@export var tolerance: float = 10  # Distance tolerance to stop moving

func _tick(_delta: float) -> Status:
	# Retrieve the target position from the blackboard
	var target_object = blackboard.get_var(target_var, Vector2.ZERO)

	# Ensure target_object is a Vector2
	if not target_object is Vector2:
		print("Error: target_object is not a Vector2")
		return FAILURE  # Return FAILURE if target_object is invalid

	var target_pos: Vector2 = target_object  # Now it's safe to assign

	# Calculate direction toward target
	var direction = agent.global_position.direction_to(target_pos)

	# Check if within tolerance range
	if agent.global_position.distance_to(target_pos) < tolerance:
		# Stop movement by setting direction to zero
		agent.move_direction = Vector2.ZERO
		return SUCCESS  # Return SUCCESS when reaching the position
	else:
		# Move towards target position
		agent.move_direction = direction.normalized() * speed_var * _delta  # Set direction with speed

		# Update animation based on movement direction
		agent.update_animation_parameters(direction)  # Call the animation update function from NPCTRYAGAIN
		return RUNNING  # Continue moving
