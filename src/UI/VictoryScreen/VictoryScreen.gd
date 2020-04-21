extends Control

var should_be_playing = false

func _ready():
	SoundManager.play_bgm("win.wav")

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	if $VideoPlayer.is_playing() == false && should_be_playing == true:
		get_tree().change_scene("res://src/MainMenu.tscn")

func _on_ButtonWhatsNext_pressed():
	$Panel.hide()
	$Label.hide()
	$ButtonWhatsNext.hide()
	should_be_playing = true
	$VideoPlayer.play()
