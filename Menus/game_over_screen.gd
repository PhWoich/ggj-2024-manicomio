extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/NewGameButton.grab_focus()

func _on_new_game_button_pressed():
	get_tree().change_scene_to_file("res://Cenas/Principal/cena_principal.tscn")


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
