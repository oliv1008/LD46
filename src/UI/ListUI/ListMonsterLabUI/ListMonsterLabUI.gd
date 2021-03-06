tool
extends Control

var main_ui

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(monster, ui):
	main_ui = ui
	$TextureRect.texture = monster.get_node("AnimatedSprite").frames.get_frame("default", 0)
	$TextureRect.modulate = monster.get_node("AnimatedSprite").modulate
	$LabelContainer/NameLabel.text = monster.monster_name
	$LabelContainer.get_node("Hp bar").init(monster)
	$LabelContainer/ScientistLvlLabel.text = str("Research speed lvl. ", monster.scientist_level)
	$LeaveButton.connect("pressed", main_ui, "on_monster_leave", [monster])
