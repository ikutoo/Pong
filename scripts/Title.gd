extends Node2D

func _on_1player_pressed():
	get_tree().change_scene("scenes/game.tscn")

func _on_2player_pressed():
	get_tree().change_scene("scenes/game.tscn")

func _on_exit_pressed():
	get_tree().quit()