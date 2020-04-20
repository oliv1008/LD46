extends Node2D

onready var max_number_of_trees = get_child_count()
var current_number_of_trees = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	for tree in get_children():
		tree.connect("tree_built", self, "on_tree_built")
	$Tree1.build()

func on_tree_built():
	if current_number_of_trees < max_number_of_trees:
		current_number_of_trees += 1
		get_node(str("Tree", current_number_of_trees)).visible = true
