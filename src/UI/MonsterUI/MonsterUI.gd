extends Panel

onready var texture = $HBoxContainer/TextureRect
onready var label_nom = $LabelNom
onready var label_food_harvester = $HBoxContainer/VBoxContainer/LabelFoodHarvesterLvl
onready var label_bone_harvester = $HBoxContainer/VBoxContainer/LabelBoneHarvesterLvl
onready var label_soldier = $HBoxContainer/VBoxContainer/LabelSoldierLvl
onready var label_scientist = $HBoxContainer/VBoxContainer/LabelScientistLvl
onready var label_romantic = $HBoxContainer/VBoxContainer/LabelRomanticLvl

var monster

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func init(monster_param):
	monster = monster_param
	texture.texture = monster.get_node("AnimatedSprite").frames.get_frame("default", 0)
	label_nom.text = monster.monster_name

func refresh():
	label_food_harvester.text = str("Food harvester lvl. : ", monster.woodcutter_level)
	label_bone_harvester.text = str("Bone harverster lvl. : ", monster.miner_level)
	label_soldier.text = str("Soldier lvl. : ", monster.soldier_level)
	label_scientist.text = str("Scientist lvl. : ", monster.scientist_level)
	label_romantic.text = str("Romantic lvl. : ", monster.fucker_level)
