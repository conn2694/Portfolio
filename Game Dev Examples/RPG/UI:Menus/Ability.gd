extends Node2D

# TODO:
# * We need a singleton (or files for when the game is loaded)
#	that will load right when the player continues. We want it
#	to enable all the abilities that were enabled last save, as well
#	as keep track of what's visible. It should be a file that has
#	all the information for every ability it should have scan which ones
#	are viewable, and then do something like
#	for every viewable ability:
#		create an ability scene, give it an appropriate name, discription
#		whether it's enabled, and the input for it.
# * To make things easy for josh in fights, whenever something is updated
#	either right when enabling/disabling an ability, or once the pause
#	menu is closed, have a function in josh's fight scene that will
#	reconfigure josh's inputs to fit with the new user configuration.
# * How abilities are actually handled should be done in Josh's character
#	scripts, both overworld and fighting
# * We should only update the viewability of an ability when one is actually
#	added through a cutscene or when josh finds one himself, doing it
#	every time we open the menu is a waste. It can be a function
#	in the menu since it'll be loaded all the time anyways.
# * turning the ability off shouldn't delete the saved input in case it was
#	on accident
# * add custom input capabilities

# Declare member variables here. Examples:
var on = false	# enabled ability or not
var viewable = false # if the player is suppose to have any control
var inputs = [] # user inputs for a move (if applicable)
var moveName = "" # name of function
var discription = "" # discription that goes in the menu box
var customInput = false # whether the user can customize the input or not
var selected = false # when hovered over in the menu
enum {UP, DOWN, LEFT, RIGHT, FP, SP, FK, SK}
const MAX_INPUTS = 7
const START_INPUT_POS = 60 # where icons begin
const INPUT_ITERATION = 10 # icon spacing


# shorthand for the input sprites
var left = preload("res://Sprites/General/Menu/Abilities/left.png")
var right = preload("res://Sprites/General/Menu/Abilities/right.png")
var up = preload("res://Sprites/General/Menu/Abilities/up.png")
var down = preload("res://Sprites/General/Menu/Abilities/down.png")
var fp = preload("res://Sprites/General/Menu/Abilities/fp.png")
var sp = preload("res://Sprites/General/Menu/Abilities/sp.png")
var fk = preload("res://Sprites/General/Menu/Abilities/fk.png")
var sk = preload("res://Sprites/General/Menu/Abilities/sk.png")

var selectedSprite = preload("res://Sprites/General/Menu/Abilities/bar select.png")
var deselectedSprite = preload("res://Sprites/General/Menu/Abilities/bar.png")
# Just to test function
func _ready():

	#loadInfo(true, true, [DOWN, RIGHT, FP], "Power Wave", 
	#"Creates a wave that rolls through the ground!")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# to be run in the singleton on every created ability scene
func loadInfo(enabled, view, inp, mvName, disc):
	on = enabled
	viewable = view
	inputs = inp
	moveName = mvName
	discription = disc
	
	get_node("Box/Label").text = mvName
	if (on):
		get_node("Box/On").visible = true
	else:
		get_node("Box/On").visible = false
		

	var i = 0
	var xPos = START_INPUT_POS
	var currInp = 0		# The current input
	for i in range(MAX_INPUTS):
		
		# i but can be used with get_node()
		var iCurr = "Box/Inputs/inp" + str(i)
		if (i < MAX_INPUTS - inputs.size()):

			get_node(iCurr).visible = false			
		else:
			
			match inputs[currInp]:
				LEFT:
					get_node(iCurr).texture = left
				RIGHT: 
					get_node(iCurr).texture = right
				UP: 
					get_node(iCurr).texture = up			
				DOWN: 
					get_node(iCurr).texture = down
				FP: 
					get_node(iCurr).texture = fp
				SP: 
					get_node(iCurr).texture = sp			
				FK: 
					get_node(iCurr).texture = fk
				SK: 
					get_node(iCurr).texture = sk
			
			get_node(iCurr).visible = true
			get_node(iCurr).position.x = xPos
			currInp += 1


		xPos += INPUT_ITERATION

func switch():
	if (on):
		on = false
		get_node("Box/On").visible = false
	else:
		on = true
		get_node("Box/On").visible = true
					
	