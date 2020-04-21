extends KinematicBody2D

var random02 = [0, 0.2, 0.4, 0.6, 0.8, 1.0]
var names = ["Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "India", "Juliett", "Kilo", "Lima", "Mike", "November", "Oscar", "Papa", "Quebec", "Romeo", "Sierra", "Tango", "Uniform", "Victor", "Whiskey", "Xray", "Yankee", "Zulu"]

export var speed = 450 #(pixels/sec)

export (int) var hp = 100

onready var animationPlayer = $AnimationPlayer

var monster_name

var woodcutter_level = 1
var miner_level = 1
var scientist_level = 1
var fucker_level = 1
var soldier_level = 1

var woodcutter_multiplier = 1
var miner_multiplier = 1
var scientist_multiplier = 1
var fucker_multiplier = 1
var soldier_multiplier = 1

var currentPos = Vector2()
var mousePos = Vector2()
var velocity = Vector2()
var posToMove = Vector2()
var batPosition = Vector2()
var ennemyPos = Vector2()

var isMoving = true

var activity = null

var is_a_soldier = false
var combat = false
var closest_ennemy = null
var isAttacking = false
var cibled_by = []

var go_to_casern = false
var pos_casern = Vector2(0, 0)

var damage = 0
export (int) var base_damage = 40

func _ready():
	randomize()
	get_node("Hp bar").init(self)
	$Hovering.modulate = Color(255,255,255,0.5)
	$AnimatedSprite.modulate = Color(random02[randi() % random02.size()], random02[randi() % random02.size()], random02[randi() % random02.size()], 1)
	monster_name = names[randi() % names.size()]
	Data.monster_list.append(self)
	Events.emit_signal("new_monster")
	Events.connect("losing_hp", self, "_on_HpDecay")
	iddle()

func _physics_process(delta):
	damage = base_damage*soldier_multiplier*Data.soldier_damage
	if is_a_soldier == false:
		if activity != null:
			if isMoving == true:
				currentPos = position
				batPosition = activity.position
				posToMove = batPosition - currentPos
				if abs(posToMove.x) > 60 || abs(posToMove.y) > 60:
					var angle = posToMove.normalized()
					velocity = posToMove.normalized() * speed
					move_and_slide(velocity, Vector2(0, 0))
					if angle.x > sqrt(2)/2 && angle.y > -sqrt(2)/2 && angle.y < sqrt(2)/2:
						go_right()
					if angle.y < -sqrt(2)/2 && angle.x > -sqrt(2)/2 && angle.x < sqrt(2)/2:
						go_up()
					if angle.x  < -sqrt(2)/2 && angle.y > -sqrt(2)/2 && angle.y < sqrt(2)/2:
						go_left()
					if angle.y > sqrt(2)/2 && angle.x > -sqrt(2)/2 && angle.x < sqrt(2)/2:
						go_down()
				else:
					isMoving = false
					activity.enter(self)
		if isMoving == false && hp > 0:
			iddle()
	
	if is_a_soldier == true:
		if Data.ennemy_list.size() > 0:
			if isMoving == true:
				currentPos = position
				ennemyPos = get_closest_ennemy_position()
				posToMove = ennemyPos - currentPos
				if not abs(posToMove.x) < 75 || not abs(posToMove.y) < 75:
					var angle = posToMove.normalized()
					velocity = posToMove.normalized() * speed
					move_and_slide(velocity, Vector2(0, 0))
					if angle.x > sqrt(2)/2 && angle.y > -sqrt(2)/2 && angle.y < sqrt(2)/2:
						go_right()
					if angle.y < -sqrt(2)/2 && angle.x > -sqrt(2)/2 && angle.x < sqrt(2)/2:
						go_up()
					if angle.x  < -sqrt(2)/2 && angle.y > -sqrt(2)/2 && angle.y < sqrt(2)/2:
						go_left()
					if angle.y > sqrt(2)/2 && angle.x > -sqrt(2)/2 && angle.x < sqrt(2)/2:
						go_down()
				else:
					isMoving = false
					combat = true
		if combat == true:
			if Data.monster_list.size() > 0:
				attack()
		if go_to_casern:
			currentPos = position
			posToMove = pos_casern - currentPos
			if not abs(posToMove.x) < 50 || not abs(posToMove.y) < 50:
				var angle = posToMove.normalized()
				velocity = posToMove.normalized() * speed
				move_and_slide(velocity, Vector2(0, 0))
				if angle.x > sqrt(2)/2 && angle.y > -sqrt(2)/2 && angle.y < sqrt(2)/2:
					go_right()
				if angle.y < -sqrt(2)/2 && angle.x > -sqrt(2)/2 && angle.x < sqrt(2)/2:
					go_up()
				if angle.x  < -sqrt(2)/2 && angle.y > -sqrt(2)/2 && angle.y < sqrt(2)/2:
					go_left()
				if angle.y > sqrt(2)/2 && angle.x > -sqrt(2)/2 && angle.x < sqrt(2)/2:
					go_down()
			else:
				go_to_casern = false
				#self.position = Vector2(0, 0)
				self.get_node("Hitbox").disabled = false
				self.visible = false

	$Hovering.texture = $AnimatedSprite.frames.get_frame("default", $AnimatedSprite.frame)
	#Peut causer des lags, bcp de fonctions pour rien
	if Data.selected == self:
		$Selected.show()
	else:
		$Selected.hide()
	
	if is_a_soldier == true:
		$SoldierIcon.show()
	else:
		$SoldierIcon.hide()


func _on_Area2D_input_event(viewport, event, shape_idx):
	#get_tree().set_input_as_handled()
	if (event is InputEventMouseButton && event.pressed): #&& isMoving == false:
		if is_a_soldier == false:
			Data.selected = self

func changeActivity(newActivity):
	if activity != null:
		activity.leave(self)
	activity = newActivity
	isMoving = true

func levelup_woodcutter():
	woodcutter_multiplier += 0.15

func levelup_miner():
	miner_multiplier += 0.15

func levelup_scientist():
	scientist_multiplier += 0.15

func levelup_fucker():
	fucker_multiplier += 0.15

func levelup_soldier():
	soldier_multiplier += 0.15

func get_closest_ennemy_position():
	var distance = Vector2()
	var best_index
	var shortest_distance = Vector2(10000, 10000)
	for i in range (0, Data.ennemy_list.size()):
		distance = 0
		distance = Data.ennemy_list[i].position - position
		if position.distance_to(distance) < position.distance_to(shortest_distance):
			shortest_distance = distance
			best_index = i
	#closest_ennemy = Data.ennemy_list[best_index]
	#closest_ennemy.cibled_by.append(self)
	return Data.ennemy_list[best_index].position

func change_closest_ennemy():
	var distance = Vector2()
	var best_index
	var shortest_distance = Vector2(10000, 10000)
	for i in range (0, Data.ennemy_list.size()):
		distance = 0
		distance = Data.ennemy_list[i].position - position
		if (position.distance_to(distance) < position.distance_to(shortest_distance)) && Data.ennemy_list[i] != closest_ennemy:
			shortest_distance = distance
			best_index = i
	closest_ennemy = Data.ennemy_list[best_index]
	#closest_ennemy.cibled_by.append(self)

func get_closest_ennemy():
	if Data.ennemy_list.size() > 0:
		var distance = Vector2()
		var best_index
		var shortest_distance = Vector2(10000, 10000)
		for i in range (0, Data.ennemy_list.size()):
			distance = 0
			distance = Data.ennemy_list[i].position - position
			if (position.distance_to(distance) < position.distance_to(shortest_distance)):
				shortest_distance = distance
				best_index = i
		closest_ennemy = Data.ennemy_list[best_index]
		#closest_ennemy.cibled_by.append(self)
		return true
	else:
		return false
	
func attack():
	if isAttacking == false:
		$DealDamage.start()
		isAttacking = true

func deal_damage():
	if (get_closest_ennemy()):
		closest_ennemy.get_hit(damage)
		nouvelle_cible()
		var floor_value = floor(soldier_level)
		soldier_level += 0.02/floor_value
		if floor(soldier_level) > floor_value:
			levelup_soldier()

func nouvelle_cible():
	#$DealDamage.stop()
	isMoving = true
	combat = false
	isAttacking = false
	get_closest_ennemy()

func _on_HpDecay():
	hp -= 1
	if(hp <= 0):
		animationPlayer.play("die")

func get_hit(damage):
	hp -= damage
	if(hp <= 0):
		animationPlayer.play("die")

func die():
	is_a_soldier = false
	Events.emit_signal("monster_death")
	if activity != null:
		activity.on_monster_leave(self)
	Data.monster_list.remove(Data.monster_list.find(self))
	if Data.selected == self:
		Data.selected = null
	self.visible = false
	self.damage = 0
	queue_free()

func clear_cibled_by(ennemy):
	if cibled_by.find(ennemy):
		cibled_by.remove(cibled_by.find(ennemy))

func iddle():
	animationPlayer.play("iddle")

func go_up():
	animationPlayer.play("moveUp")

func go_left():
	animationPlayer.play("moveLeft")

func go_right():
	animationPlayer.play("moveRight")

func go_down():
	animationPlayer.play("moveDown")

func _on_Area2D_mouse_entered():
	$Hovering.show() 

func _on_Area2D_mouse_exited():
	$Hovering.hide()

func _on_DealDamage_timeout():
	animationPlayer.play("attack")
	deal_damage()


func _on_AnimationPlayer_animation_changed(old_name, new_name):
	if old_name == "attack":
		$AnimatedSprite.rotation_degrees = 0

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		$AnimatedSprite.rotation_degrees = 0
