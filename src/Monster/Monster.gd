extends KinematicBody2D

var random02 = [0, 0.2, 0.4, 0.6, 0.8, 1.0]
var names = ["Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "India", "Juliett", "Kilo", "Lima", "Mike", "November", "Oscar", "Papa", "Quebec", "Romeo", "Sierra", "Tango", "Uniform", "Victor", "Whiskey", "Xray", "Yankee", "Zulu"]

export var speed = 450 #(pixels/sec)

export (int) var hp = 100

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
var isMoving

var activity = null

func _ready():
	randomize()
	$AnimatedSprite.modulate = Color(random02[randi() % random02.size()], random02[randi() % random02.size()], random02[randi() % random02.size()], 1)
	monster_name = names[randi() % names.size()]
	iddle()

func _physics_process(delta):
	if activity != null:
		if isMoving == true:
			currentPos = position
			batPosition = activity.position
			posToMove = batPosition - currentPos
			if abs(posToMove.x) > 5 || abs(posToMove.y) > 5:
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

	if activity == null && hp > 0:
		iddle()
		
func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		Data.selected = self
		print("Data.selected = ", Data.selected)

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


func _on_HpDecay_timeout():
	hp -= 1
	if(hp <= 0):
		var animationPlayer = $AnimationPlayer
		animationPlayer.play("die")
	
func die():
	changeActivity(null)
	queue_free()
	
func iddle():
	var animationPlayer = $AnimationPlayer
	animationPlayer.play("iddle")

func go_up():
	var animationPlayer = $AnimationPlayer
	animationPlayer.play("moveUp")

func go_left():
	var animationPlayer = $AnimationPlayer
	animationPlayer.play("moveLeft")

func go_right():
	var animationPlayer = $AnimationPlayer
	animationPlayer.play("moveRight")

func go_down():
	var animationPlayer = $AnimationPlayer
	animationPlayer.play("moveDown")
