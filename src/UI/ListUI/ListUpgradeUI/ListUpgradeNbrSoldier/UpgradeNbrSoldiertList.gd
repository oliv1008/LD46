extends Control


onready var description_label = $VBoxContainer2/DescriptionLabel
onready var cost_label = $VBoxContainer2/CostLabel
onready var research_button = $VBoxContainer/ResearchButton
export (int) var initial_cost = 12

func init(level):
	var cost = round(level * 0.25 + initial_cost)
	cost_label.text = str("Cost : ", cost, "bones")
