extends Popup


# Called when the node enters the scene tree for the first time.
func _ready():
	add_button("BACK")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_controls_button_pressed():
	popup_centered_ratio(0.5)
