extends HBoxContainer

var main_ui
var cost_soldier = 8
onready var build_button = $BuildButtonContainer/BuildButton
onready var available_max_value_label = $AvailableMaxValue

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("new_ressources_value", self, "_on_ressources_values_changed")

func init(ui):
	main_ui = ui
	
func _physics_process(delta):
	if main_ui:	
		available_max_value_label.text = str(main_ui.barrack.current_weapon_quantity, " / ", main_ui.barrack.max_weapon_quantity)
	
func _on_ressources_values_changed(type, new_value):
	if main_ui != null:
		if (type == Events.RessourcesType.bone):
			if new_value >= cost_soldier && main_ui.is_soldier_available():
				build_button.disabled = false
			else:
				build_button.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_BuildButton_pressed():
	Events.emit_signal("use_bones", cost_soldier)
	main_ui._on_soldier_created()
