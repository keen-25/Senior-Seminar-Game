extends Control
# DialogPopup.gd
#extends CanvasLayer
#@onready var dialog_label: Label = $Panel/Name_message
#@onready var dialog_label: Label = $DialogLabel
#@onready var response_label: Label = $ResponseLabel
#@onready var response_label: Label = $Panel/Response
@onready var name_: RichTextLabel = $Panel/name
@onready var message_: RichTextLabel = $Panel/message
@onready var response_: RichTextLabel = $Panel/response

signal response_selected(option: String)

func _ready():
	print("this is", message_, response_)
	print("Is visible:", visible)
	$Panel.visible = true
	$Panel/message.visible = true
	$Panel/response.visible = true
	print("DialogPopup visibility:", visible)
	print("Panel visibility:", $Panel.visible)
	print("Name_message visibility:", $Panel/message.visible)
	print("Response visibility:", $Panel/response.visible)

# Show a dialog with responses
func show_dialog(message: String, responses: Array):
	print("Message:", message)
	print("Responses:", responses)
	message_.text = message
	print("Dialog Label:", $Panel/message.text)
	message_.queue_redraw()  # Adjust size as needed
	response_.text = "\n".join(responses)
	print("Response Label:", response_.text)
	response_.queue_redraw()
	visible = true
	print("Visible:", visible)
	#dialog_label.update()
	#response_label.update()

# Handle player input for responses
func _input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("response_selected", "Y")
		visible = false
	elif event.is_action_pressed("ui_cancel"):
		emit_signal("response_selected", "N")
		visible = false
