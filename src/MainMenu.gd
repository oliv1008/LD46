extends Control

var should_be_playing = false
var dontplay = false

func _physics_process(delta):
	if $VideoPlayer.is_playing() == false && should_be_playing == true:
		get_tree().change_scene("res://src/Main.tscn")
	if SoundManager.is_bgm_playing("animal crossing 2.wav") == false && dontplay == false:
		SoundManager.play_bgm("animal crossing 2.wav")

func _on_Start_pressed():
	dontplay = true
	SoundManager.stop_bgm("animal crossing 2.wav")
	$Background.hide()
	$Sprite2.hide()
	$Start.hide()
	$Exit.hide()
	should_be_playing = true
	$VideoPlayer.play()

func _on_Exit_pressed():
	get_tree().quit()
