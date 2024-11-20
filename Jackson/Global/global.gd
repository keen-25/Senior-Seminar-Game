extends Node2D

var hotbar_instance: Hotbar = null

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func set_hotbar(instance: Hotbar) -> void:
	hotbar_instance = instance


#create a global variable called Global in your game
