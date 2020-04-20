extends Node2D

onready var max_number_of_bones = get_child_count()
var current_number_of_bones = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	for bone in get_children():
		bone.connect("bone_built", self, "on_bone_built")
	$Bone1.build()

func on_bone_built():
	if current_number_of_bones < max_number_of_bones:
		current_number_of_bones += 1
		get_node(str("Bone", current_number_of_bones)).visible = true
