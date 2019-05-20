extends Sprite

func _on_PlayAgain_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false

func _on_Return_pressed():
	get_tree().change_scene("scenes/title.tscn")
	get_tree().paused = false