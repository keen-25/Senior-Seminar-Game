extends ColorRect
@onready var value: ColorRect = $value


func update_stamina_ui(stamina, max_stamina):
	value.size.x = 98 * stamina / max_stamina
