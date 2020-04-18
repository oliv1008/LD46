extends Node

signal new_ressources_generator(type, user)
signal delete_ressources_generator(type, user)

signal new_ressources_value(type, value)

enum RessourcesType {food, bone}
enum WeaponChoices {SPEAR}
