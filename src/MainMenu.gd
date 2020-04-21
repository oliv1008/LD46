extends Control

var should_be_playing = false

func _physics_process(delta):
	if $VideoPlayer.is_playing() == false && should_be_playing == true:
		get_tree().change_scene("res://src/Didacticiel/Didacticiel1/Didacticiel1.tscn")

func _on_Start_pressed():
	$Background.hide()
	$Sprite2.hide()
	$Start.hide()
	$Exit.hide()
	should_be_playing = true
	$VideoPlayer.play()

func _on_Exit_pressed():
	get_tree().quit()
