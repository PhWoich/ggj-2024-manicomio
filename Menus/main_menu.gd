extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed():
	#get_tree().change_scene("res://Cenas/Principal/cena_principal.tscn")
	get_tree().change_scene_to_file("res://Cenas/Principal/cena_principal.tscn")

func _on_exit_button_pressed():
	get_tree().quit()

