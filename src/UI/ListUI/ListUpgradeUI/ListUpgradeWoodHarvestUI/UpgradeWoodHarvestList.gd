extends Control


onready var description_label = $VBoxContainer2/DescriptionLabel
onready var cost_label = $VBoxContainer2/CostLabel
onready var research_button = $VBoxContainer/ResearchButton
var cost
export (int) var initial_cost = 10

func init(level):
	Events.connect("new_ressources_value", self, "_on_ressources_values_changed")
	cost = round(level * 0.25 + initial_cost)
	cost_label.text = str("Cost : ", cost, "bones")

func _on_ressources_values_changed(type, new_value):
	if (type == Events.RessourcesType.bone):
		if new_value >= cost:
			research_button.disabled = false
		else:
			research_button.disabled = true
