extends Node

signal new_ressources_generator(type, user)
signal delete_ressources_generator(type, user)

signal new_ressources_value(type, value)
signal new_ressources_per_sec_value(type, value)

signal new_food_needed_per_tick(value)

signal new_monster()
signal monster_death()

signal losing_hp()

signal use_bones(value)

signal new_research_state(actual_value, final_value)
signal new_research(image)
signal end_research()

signal disable_lab_button()
signal enable_lab_button()





enum RessourcesType {food, bone}
enum WeaponChoices {SPEAR}
