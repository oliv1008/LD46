extends HBoxContainer


onready var description_label = $VBoxContainer2/DescriptionLabel
onready var cost_label = $VBoxContainer2/HBoxContainer/CostLabel
onready var research_button = $VBoxContainer/ResearchButton
export (int) var initial_cost = 11
export (int) var initial_research_cost = 30
var cost = 11
var research_cost = 30

signal upgrade_selected(type, upgrade)

func init(level):
	Events.connect("disable_lab_button", self, "on_disable_lab_button")
	Events.connect("enable_lab_button", self, "on_enable_lab_button")
	Events.connect("new_ressources_value", self, "_on_ressources_values_changed")
	cost = round(initial_cost * pow(2, level))
	research_cost = round(level * initial_research_cost)
	cost_label.bbcode_text = str(cost, " [img]res://assets/Graphics/Icon/Icon os ps25.png[/img]\n", research_cost, " [img]res://assets/Graphics/Icon/icon science25.png[/img]")
	
func _on_ressources_values_changed(type, new_value):
	if (type == Events.RessourcesType.bone):
		if new_value >= cost && Data.lab_button_disabling == false:
			research_button.disabled = false
		else:
			research_button.disabled = true

func on_disable_lab_button():
	Data.lab_button_disabling = true
	research_button.disabled = true

func on_enable_lab_button():
	Data.lab_button_disabling = false
	research_button.disabled = false


func _on_ResearchButton_pressed():
	emit_signal("upgrade_selected", Data.Upgrades.BONE_HARVEST, self)
