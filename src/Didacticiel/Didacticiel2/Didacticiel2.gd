extends Node2D

var foods = 0
var bones = 0

var food_per_tick = 0
var bone_per_tick = 0

var food_needed_per_tick = 0.6
var food_needed_per_person = 0.2

onready var popup_ui = $PopUpUI

var first_popup_text = ["As I just said, your colony needs food to survive, but it's not the only ressource available. You can also harvest bones which will be useful to the growth of the colony.\nAssign bacteria to one of each ressources the same way you assigned them into the nest."]
var second_popup_text = ["You are now recolting bones, let's see how to use these.\n\nFirst, there is the lab, a building in which you can research upgrade for your colony ... as long as you can pay the cost and have a bacteria assigned to it.\n\nThen there are the barracks, in which you can build weapons and arm your bacteria ... in case of unwanted visitors ...\n\nAnd I even heard you can use them to build even more harvest spots for foods and bones ! Aaaah, technology these days ...",
						"Oh ! And I almost forgot the most important !\nYour goal is to grow the colony to 20 bacterias.\n\nWell, I hope it wasn't too much information ! I'll let you time to digest everything before you start for real, good luck !"]

enum Steps {FIRST_POPUP, HARVEST, SECOND_POPUP, END}
var current_step = Steps.FIRST_POPUP

export (PackedScene) var Main

func _ready():
	SoundManager.play_bgm("Animal crossing.wav")
	$Nest.build()
	$Tree.build()
	$Bone.build()
	$Lab.build()
	$Barrack.build()
	get_tree().paused = true
	popup_ui.init(first_popup_text)
	popup_ui.connect("end_reached", self, "on_end_reached")

func goto_next_step():
	if current_step == Steps.FIRST_POPUP:
		get_tree().paused = false
		Events.connect("new_ressources_generator", self, "add_ressources_per_tick")
		Events.connect("delete_ressources_generator", self, "delete_ressources_per_tick") 
		Events.connect("new_monster", self, "on_new_monster")
		Events.connect("monster_death", self, "on_monster_death")
		Events.connect("use_bones", self, "on_use_bones")
		popup_ui.visible = false
		Events.connect("button_mate_pressed", self, "on_button_mate_pressed")
		current_step = Steps.HARVEST
	
	elif current_step == Steps.HARVEST:
		popup_ui.init(second_popup_text)
		popup_ui.visible = true
		current_step = Steps.SECOND_POPUP
		
	elif current_step == Steps.SECOND_POPUP:
		$ButtonLetsGo.visible = true
		$Lab.visible = true
		$Barrack.visible = true
		popup_ui.visible = false
		current_step = Steps.END
	
func on_end_reached():
	if current_step == Steps.FIRST_POPUP:
		goto_next_step()
	
	elif current_step == Steps.SECOND_POPUP:
		goto_next_step()
	
func _on_ButtonLetsGo_pressed():
	get_tree().change_scene_to(Main)
	
func _physics_process(delta):
	if Data.selected != null:
		$MonsterUI.init(Data.selected)
		$MonsterUI.refresh()
		$MonsterUI.visible = true
	else:
		$MonsterUI.visible = false
		
func _process(delta):
	if food_per_tick > 0 && bone_per_tick > 0 && current_step == Steps.HARVEST:
		goto_next_step()

func add_ressources_per_tick(type: int, user):
	if (type == Events.RessourcesType.food):
		food_per_tick += 1*user.woodcutter_multiplier
		Events.emit_signal("new_ressources_per_sec_value", Events.RessourcesType.food, food_per_tick)
	if (type == Events.RessourcesType.bone):
		bone_per_tick += 1*user.miner_multiplier
		Events.emit_signal("new_ressources_per_sec_value", Events.RessourcesType.bone, bone_per_tick)

func delete_ressources_per_tick(type: int, user):
	if (type == Events.RessourcesType.food):
		food_per_tick -= 1*user.woodcutter_multiplier
		Events.emit_signal("new_ressources_per_sec_value", Events.RessourcesType.food, food_per_tick)
	if (type == Events.RessourcesType.bone):
		bone_per_tick -= 1*user.miner_multiplier
		Events.emit_signal("new_ressources_per_sec_value", Events.RessourcesType.bone, bone_per_tick)

func on_new_monster():
	print("nouveau monstre !")
	food_needed_per_tick += food_needed_per_person
	Events.emit_signal("new_food_needed_per_tick", food_needed_per_tick)
	
func on_monster_death():
	food_needed_per_tick -= food_needed_per_person
	Events.emit_signal("new_food_needed_per_tick", food_needed_per_tick)

func _on_FoodTimer_timeout():
	foods += food_per_tick*Data.food_harvest_speed
	if food_per_tick > 0:
		Events.emit_signal("new_ressources_value", Events.RessourcesType.food, foods)

func _on_MaterialTimer_timeout():
	bones += bone_per_tick*Data.bone_harvest_speed
	if bone_per_tick > 0:
		Events.emit_signal("new_ressources_value", Events.RessourcesType.bone, bones)

func _on_HpDecay_timeout():
	if foods < food_needed_per_tick:
		Events.emit_signal("losing_hp")
	else:
		foods -= food_needed_per_tick
		Events.emit_signal("new_ressources_value", Events.RessourcesType.food, foods)

func on_use_bones(value):
	bones -= value
	Events.emit_signal("new_ressources_value", Events.RessourcesType.bone, bones)
