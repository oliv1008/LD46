extends Node2D

var food_needed_per_tick = 1
var food_needed_per_person = 0.5

onready var popup_ui = $PopUpUI

var first_popup_text = ["Hello ! Welcome to MitosiVilization !\nYour goal in this game will be to help a colony of bacteria to grow and protect them from extinction !\nLet's start by quickly walking you through the basics.", 
						"The building you're seeing here is the nest. It is used by your bacterias to reproduce.\nYou can click on your bacterias and then on the nest to send them inside.\nOnce you've done that, click on the nest to open the nest menu and start the mating process !"]
var second_popup_text = ["Congratulations, a new bacteria is on the way !\nBut be wary ! Each bacteria need food in order to survive, make sure your food production is greater than the food needs of your colony, or they risk starving to death ...\nSince the mating process is a little bit long we're gonna speed things a bit here, click \"next\" when you're ready"]

enum Steps {FIRST_POPUP, MATE, SECOND_POPUP}
var current_step = Steps.FIRST_POPUP

export (PackedScene) var Didacticiel2

func _ready():
	SoundManager.play_bgm("Animal crossing.wav")
	Events.connect("new_monster", self, "on_new_monster")
	$Nest.build()
	get_tree().paused = true
	popup_ui.init(first_popup_text)
	popup_ui.connect("end_reached", self, "on_end_reached")
	
func goto_next_step():
	if current_step == Steps.FIRST_POPUP:
		get_tree().paused = false
		popup_ui.visible = false
		Events.connect("button_mate_pressed", self, "on_button_mate_pressed")
		current_step = Steps.MATE
	
	elif current_step == Steps.MATE:
		popup_ui.init(second_popup_text)
		popup_ui.visible = true
		current_step = Steps.SECOND_POPUP
	
func on_end_reached():
	if current_step == Steps.FIRST_POPUP:
		goto_next_step()
	
	elif current_step == Steps.SECOND_POPUP:
		get_tree().change_scene_to(Didacticiel2)
		
func on_button_mate_pressed():
	if current_step == Steps.MATE:
		goto_next_step()
	
func _physics_process(delta):
	if Data.selected != null:
		$MonsterUI.init(Data.selected)
		$MonsterUI.refresh()
		$MonsterUI.visible = true
	else:
		$MonsterUI.visible = false

func on_new_monster():
	print("nouveau monstre !")
	food_needed_per_tick += food_needed_per_person
	Events.emit_signal("new_food_needed_per_tick", food_needed_per_tick)
