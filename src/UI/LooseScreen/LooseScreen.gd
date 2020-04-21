extends Control

var main_path = "res://src/Main.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	SoundManager.play_bgm("GAME OVER.wav")

func _on_ButtonTryAgain_pressed():
	get_tree().change_scene(main_path)


func _on_ButtonExit_pressed():
	get_tree().quit()
