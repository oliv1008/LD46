extends KinematicBody2D

export (int) var pv = 5
var mouvementSpeed = 200

onready var raycast = $RayCast2D

var dontMove = false
var currentPos = Vector2()
var monsterPos = Vector2()
var velocity = Vector2()
var posToMove = Vector2()
var player = false


onready var Hurtbox = $Area2D/Hurtbox
onready var Hitbox = $Hitbox

func _ready():
	pass

func _physics_process(delta):
	if Data.monster_list.size() > 0:
		currentPos = position
		monsterPos = get_closest_monster_position()
		posToMove = monsterPos - currentPos
		if not dontMove && not abs(posToMove.x) < 2 || not abs(posToMove.y) < 2:
			look_at(monsterPos)
			velocity = posToMove.normalized() * mouvementSpeed
			move_and_slide(velocity, Vector2(0, 0))

	if raycast.is_colliding() && raycast.get_collider().is_in_group("monsters"):
		dontMove = true
		attack()

	if pv <= 0:
		var animationPlayer = $AnimationPlayer
		animationPlayer.play("die")
		dontMove = true
		Hitbox.disabled = true
		Hurtbox.disabled = true
	
func get_hit(degats):
	pv -= degats

func attack():
	var animationPlayer = $AnimationPlayer
	if !animationPlayer.is_playing():
		animationPlayer.play("attack")
	
func die():
	queue_free()

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
	return Data.monster_list[best_index].position

#Quand l'animation d'attaque se fini on autorise l'enemie à bouger à nouveau
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		dontMove = false

#Quand la hitbox d'attaque de l'enemie touche un autre corps
func _on_Area2D_body_entered(body):
	if body == self:
		pass
	else:
		if (body.has_method("get_hit") && body.is_in_group("monsters")):
			body.get_hit()

