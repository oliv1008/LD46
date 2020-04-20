extends HBoxContainer

onready var bone_icon_path = "res://assets/Graphics/Icon/Icon os ps.png"
onready var science_icon_path = "res://assets/Graphics/Icon/icon science.png"

onready var description_label = $VBoxContainer2/DescriptionLabel
onready var cost_label = $VBoxContainer2/HBoxContainer/CostLabel
onready var research_button = $VBoxContainer/ResearchButton
var cost
var research_cost
export (int) var initial_cost = 10
export (int) var initial_research_cost = 30

var disabling = false

signal upgrade_selected(type, upgrade)

func init(level):
	Events.connect("disable_lab_button", self, "on_disable_lab_button")
	Events.connect("enable_lab_button", self, "on_enable_lab_button")
	Events.connect("new_ressources_value", self, "_on_ressources_values_changed")
	cost = round(level * initial_cost)
	research_cost = round(level * initial_research_cost)
	cost_label.bbcode_text = str(cost, " [img]res://assets/Graphics/Icon/Icon os ps25.png[/img]\n", research_cost, " [img]res://assets/Graphics/Icon/icon science25.png[/img]")
	
func _on_ressources_values_changed(type, new_value):
	if (type == Events.RessourcesType.bone):
		if new_value >= cost && disabling == false:
			research_button.disabled = false
		else:
			research_button.disabled = true

func on_disable_lab_button():
	disabling = true
	research_button.disabled = true

func on_enable_lab_button():
	disabling = false
	research_button.disabled = false

func _on_ResearchButton_pressed():
	emit_signal("upgrade_selected", Data.Upgrades.WOOD_HARVEST, self)
