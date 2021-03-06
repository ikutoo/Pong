extends Node2D

func _on_1player_pressed():
	Global.gameMode = Global.GAME_MODE_ONE_PLAYER
	get_tree().change_scene("scenes/selectDifficulty.tscn")

func _on_2player_pressed():
	Global.gameMode = Global.GAME_MODE_TWO_PLAYER
	get_tree().change_scene("scenes/game.tscn")

func _on_demo_pressed():
	Global.gameMode = Global.GAME_MODE_AUTO_PLAY
	Global.difficultyLevel = Global.DIFFICULTY_LEVEL_LEGEND
	get_tree().change_scene("scenes/game.tscn")
	
func _on_exit_pressed():
	get_tree().quit()