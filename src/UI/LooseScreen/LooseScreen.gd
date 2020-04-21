extends Control

var main_path = "res://src/Main.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ButtonTryAgain_pressed():
	get_tree().change_scene(main_path)


func _on_ButtonExit_pressed():
	get_tree().quit()
