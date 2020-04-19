extends Node

signal new_ressources_generator(type, user)
signal delete_ressources_generator(type, user)

signal new_ressources_value(type, value)
signal new_ressources_per_sec_value(type, value)

signal new_food_needed_per_tick(value)

signal use_bones(value)

signal new_monster()
signal monster_death()

signal losing_hp()





enum RessourcesType {food, bone}
enum WeaponChoices {SPEAR}
