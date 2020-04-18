extends KinematicBody2D

export var speed = 450 #(pixels/sec)

export (int) var hp = 100

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

var activated # = true si la souris est sur le monstre, false sinon

var activity = null

func _ready():
	pass 

func _physics_process(delta):
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		currentPos = position
		mousePos = get_global_mouse_position()
		posToMove = mousePos - currentPos
		if not abs(posToMove.x) < 15 && not abs(posToMove.y) < 15:
			look_at(mousePos)
			velocity = posToMove.normalized() * speed
			move_and_slide(velocity, Vector2(0, 0))
			#move_and_collide(velocity * delta)
		else:
			pass

	if Input.is_action_just_pressed("BUTTON_LEFT") && activated == true:
		Data.selected = self

func _on_Area2D_mouse_entered():
	activated = true

func _on_Area2D_mouse_exited():
	activated = false

func changeActivity(newActivity):
	if activity != null:
		activity.user = null
	activity = newActivity
	print("ma nouvelle activité est : ", newActivity)

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
