extends HBoxContainer

var main_ui

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(monster, ui):
	main_ui = ui
	$TextureRect.texture = monster.get_node("AnimatedSprite").frames.get_frame("default", 0)
	$TextureRect.modulate = monster.get_node("AnimatedSprite").modulate
	$VBoxContainer/NameLabel.text = monster.monster_name
	$VBoxContainer.get_node("Hp bar").init(monster)
	$VBoxContainer/SoldierLvlLabel.text = str("Soldier lvl. ", monster.soldier_level)
	$VBoxContainer2/ButtonKick.connect("pressed", main_ui, "on_monster_leave", [monster])
	$VBoxContainer2/ButtonEquip.connect("pressed", main_ui, "on_monster_equipped", [monster])
