extends Control

func _on_Easy_pressed():
	Global.difficultyLevel = Global.DIFFICULTY_LEVEL_EASY
	get_tree().change_scene("scenes/game.tscn")
func _on_Normal_pressed():
	Global.difficultyLevel = Global.DIFFICULTY_LEVEL_NORMAL
	get_tree().change_scene("scenes/game.tscn")

func _on_Hard_pressed():
	Global.difficultyLevel = Global.DIFFICULTY_LEVEL_HARD
	get_tree().change_scene("scenes/game.tscn")

func _on_Legend_pressed():
	Global.difficultyLevel = Global.DIFFICULTY_LEVEL_LEGEND
	get_tree().change_scene("scenes/game.tscn")

func _on_Legend_focus_entered():
	pass # Replace with function body.
