extends KinematicBody2D

export (int) var hp = 100
var mouvementSpeed = 200
export (int) var damage = 10

onready var animationPlayer = $AnimationPlayer

var dontMove = false

var currentPos = Vector2()
var monsterPos = Vector2()
var velocity = Vector2()
var posToMove = Vector2()

var player = false
var closest_monster = null
var cibled_by = []

var combat = false
var isAttacking = false

onready var Hitbox = $Hitbox

func _ready():
	Data.ennemy_list.append(self)
	get_node("Hp bar").init(self)
	$AnimatedSprite.modulate = Color(255, 0, 0, 1)
	get_closest_monster()

func _physics_process(delta):
	if Data.monster_list.size() > 0:
		if dontMove == false:
			currentPos = position
			monsterPos = get_closest_monster_position()
			posToMove = monsterPos - currentPos
			if not abs(posToMove.x) < 75 || not abs(posToMove.y) < 75:
				var angle = posToMove.normalized()
				velocity = posToMove.normalized() * mouvementSpeed
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
				dontMove = true
				combat = true
				isAttacking = false

	if combat == true:
		if Data.monster_list.size() > 0:
			attack()

	if hp <= 0:
		animationPlayer.play("die")
		dontMove = true
		Hitbox.disabled = true
	
func get_hit(degats):
	hp -= degats

func attack():
	if isAttacking == false:
		$DealDamage.start()
		isAttacking = true
	
func die():
	Data.ennemy_list.remove(Data.ennemy_list.find(self))
	if Data.ennemy_list.size() == 0:
		Events.emit_signal("no_more_ennemies")
	queue_free()

func clear_cibled_by(monster):
	if cibled_by.find(monster):
		cibled_by.remove(cibled_by.find(monster))

func nouvelle_cible():
	dontMove = false
	combat = false
	isAttacking = false
	get_closest_monster()

func get_closest_monster_position():
	var distance = Vector2()
	var best_index
	var shortest_distance = Vector2(10000, 10000)
	for i in range (0, Data.monster_list.size()):
		distance = 0
		distance = Data.monster_list[i].position - position
		if position.distance_to(distance) < position.distance_to(shortest_distance):
			shortest_distance = distance
			best_index = i
	#closest_monster = Data.monster_list[best_index]
	#closest_monster.cibled_by.append(self)
	return Data.monster_list[best_index].position

func get_closest_monster():
	if Data.monster_list.size() > 0:
		var distance = Vector2()
		var best_index
		var shortest_distance = Vector2(10000, 10000)
		for i in range (0, Data.monster_list.size()):
			distance = 0
			distance = Data.monster_list[i].position - position
			if position.distance_to(distance) < position.distance_to(shortest_distance):
				shortest_distance = distance
				best_index = i
		closest_monster = Data.monster_list[best_index]
		#closest_monster.cibled_by.append(self)
		return true
	else:
		return false


func change_closest_monster():
	var distance = Vector2()
	var best_index
	var shortest_distance = Vector2(10000, 10000)
	for i in range (0, Data.monster_list.size()):
		distance = 0
		distance = Data.monster_list[i].position - position
		if (position.distance_to(distance) < position.distance_to(shortest_distance)) && Data.monster_list[i] != closest_monster:
			shortest_distance = distance
			best_index = i
	closest_monster = Data.monster_list[best_index]
	closest_monster.cibled_by.append(self)

func deal_damage():
	if (get_closest_monster()):
		closest_monster.get_hit(damage)
		nouvelle_cible()

func go_up():
	animationPlayer.play("moveUp")

func go_left():
	animationPlayer.play("moveLeft")

func go_right():
	animationPlayer.play("moveRight")

func go_down():
	animationPlayer.play("moveDown")

func _on_DealDamage_timeout():
	animationPlayer.play("attack")
	deal_damage()
