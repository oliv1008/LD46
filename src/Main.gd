extends Node2D

var foods = 0
var bones = 0

var food_per_tick = 0
var bone_per_tick = 0

var food_needed_per_tick = 4
var food_needed_per_person = 0.5

var current_wave_level = 0
var current_time_before_next_wave = 120
var time_before_next_wave = [120, 90, 60, 45, 30]
var number_of_mobs_per_wave = [1, 2, 2, 3, 3]

onready var lab = $Lab

export (PackedScene) var ennemy

func _ready():
	Events.connect("new_ressources_generator", self, "add_ressources_per_tick")
	Events.connect("delete_ressources_generator", self, "delete_ressources_per_tick") 
	Events.connect("new_monster", self, "on_new_monster")
	Events.connect("monster_death", self, "on_monster_death")
	Events.connect("use_bones", self, "on_use_bones")
	
func _physics_process(delta):
	if Data.selected != null:
		$MonsterUI.init(Data.selected)
		$MonsterUI.refresh()
		$MonsterUI.visible = true
	else:
		$MonsterUI.visible = false
	if Input.is_action_pressed("ui_cancel"):
		on_pause_pressed()
	if SoundManager.is_bgm_playing("Animal crossing.wav") == false:
		SoundManager.play_bgm("Animal crossing.wav")

func on_pause_pressed():
	get_tree().paused = true
	$HpDecay.paused = true
	$FoodTimer.paused = true
	$TimerNextWave.paused = true
	$MaterialTimer.paused = true
	$pause_popup.show()

func on_resume():
	get_tree().paused = false
	$HpDecay.paused = false
	$FoodTimer.paused = false
	$TimerNextWave.paused = false
	$MaterialTimer.paused = false
	$pause_popup.hide()

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

func spawn_wave():
	for i in range (0, number_of_mobs_per_wave[current_wave_level]):
		var new_ennemy = ennemy.instance()
		if i == 0:
			new_ennemy.position = $SpawnEnnemyTimer/SpawnPosition1.global_position
		if i == 1:
			new_ennemy.position = $SpawnEnnemyTimer/SpawnPosition2.global_position
		if i == 2:
			new_ennemy.position = $SpawnEnnemyTimer/SpawnPosition3.global_position
		self.add_child(new_ennemy)
	Events.emit_signal("ennemy_spawned")

func _on_TimerNextWave_timeout():
	if (current_time_before_next_wave == 0):
		spawn_wave()
		if current_wave_level != 4:
			current_wave_level =+ 1
		current_time_before_next_wave = time_before_next_wave[current_wave_level]
	current_time_before_next_wave -= 1
	Events.emit_signal("new_next_wave_value", current_time_before_next_wave)
