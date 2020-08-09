extends Node2D

# TODO:
# * Create a scrollbar of some kind so the player can go down to further
#	moves after they've gotten more than the screen can handle.
#	Player will press down at the last one before moving the other items up one
#	one unit, this will hide one at the top. Could also be two buttons used
#	as tabs to do a PageDown and PageUp sort of function. We can hide things
#	wish a mask if we'd like to go that route

const HOR_POS = 62
const INIT_VERT = 50
const VERT_SPACING = 15

var loadAb = preload("res://Scenes/General/Menus/Abilities/ability.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# to be done every time we want to add a new ability, and when the save
# file is loaded
func updateAbilityList():
	# just one at the moment, will expand for multiple

	for i in range(AbilityData.ability.size()):

		var abil = loadAb.instance()
		
		abil.loadInfo(AbilityData.ability[i].enabled, 
		AbilityData.ability[i].visible, AbilityData.ability[i].input, 
		AbilityData.ability[i].name, AbilityData.ability[i].discription)
		
		abil.visible = true
		abil.position = Vector2(HOR_POS, INIT_VERT + (VERT_SPACING * (i)))

		
		add_child(abil)
		

	
	get_node("Ability").visible = true
	get_node("Ability").position = Vector2(62, 50)
	pass