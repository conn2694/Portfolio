extends Node2D

# TODO:
# * We will want to make a loader that loads all the areas in Valance,
#	Madel, and the 4 districts of tomaya so that you only have to load
#	when going between one of them. Create a loader singleton
#	that will make this loading smooth. Also include in it our
#	loading transitions, and include a function that loads our new
#	scene and and deletes the previous scene (when entering a new scene,
#	save the scene name with right when it loads into a variable in the
#	singleton) and use these as the code for replacing the scene
#		#get_tree().get_root().add_child(newScene)
		#get_node("/root/Old Scene First node name").free()
# * Make a ramp and make sure the game doesn't confuse it for a teleport
#	just because it's an Area2D. maybe have it be in a group and make 
#	it so that group canTeleport in our Josh scene won't work if it
#	has that area.
# * Fix teleporting on instant by pressing a button, it should do nothing


var dialogueData = preload("res://Scenes/General/Text Box/TextBubbles.tscn")
var fightTest = preload("res://Scenes/Fighting/Core/CoreTest.tscn")
var currentLocation = null
var fightLoaded = false
var josh = null
var instantDone = 0

# special variables
var upstairs = true
#var loadValance = null
#var valInstance = null

func _ready():
	# change this variable whenever we trigger an area2d that teleports us somewhere
	# else, right now we start in josh's room
	currentLocation = "Josh's Room"
	josh = get_node("Objects/Josh")
	#loadValance = load("res://Scenes/Overworld/Areas/Valance.tscn")
	#valInstance = loadValance.instance()


func _physics_process(delta):
	# tests fighting game overlay
#	if (Input.is_action_just_pressed("Create") && !fightLoaded):
#		var test = fightTest.instance()
#		add_child(test)
#		fightLoaded = true

	# No need to run this code unless we can interact with something
	if (OverworldVariables.canWalk):
		
		
		if (OverworldVariables.isInteractible):

			if (Input.is_action_just_pressed("Action")):
				
				# Have a seperate for loop for anything that would trigger a cutscene,
				# we want that having different logic than loadTextBox
	
				#compare OverworldVariables.storedDialogue.get_name() to all of our hitboxes to
				#make sure it has dialogue with it, this is to make sure we don't
				#try to load dialogue that doesn't exist and crash the game.
				var storedDialogueName = OverworldVariables.storedDialogue
				var objectTests = "Map/" + currentLocation + "/Dialogue"
				for i in range (get_node(objectTests).get_children().size()):
	
					if (storedDialogueName == get_node(objectTests).get_children()[i].get_name()):
						# JUST TESTING SCENE TRANSITIONS
						#get_tree().get_root().add_child(valInstance)
						#get_node("/root/General").free()
						loadTextBox()
						return
						

						
						
						


			
		# Check if we can transport and then make sure it's a transport by checking the parent
		if (OverworldVariables.canTransport && OverworldVariables.transportFrom.get_parent().get_parent().get_name() == "Transporter"):
			
			var adjust = Vector2(0, 0)
			if (OverworldVariables.transportFrom.is_in_group("Left")):
				adjust.x = 20
			elif (OverworldVariables.transportFrom.is_in_group("Right")):
				adjust.x = -20
			elif (OverworldVariables.transportFrom.is_in_group("Down")):
				adjust.y = -10
			elif (OverworldVariables.transportFrom.is_in_group("Up")):
				adjust.y = 10
			
			
			# Exit's go to enter's, and vise versa
			if (OverworldVariables.transportFrom.get_parent().get_name() == "Exit"):
				# If it's an instant teleport
				if (OverworldVariables.transportFrom.is_in_group("Instant") && !instantDone):
					# instantDone is set to 2 because there is a frame in between
					# the teleport where the game doesn't consider us in an area
					# because of this it will count down to 1, and THEN when we
					# leave the area manually it will go back to 0, allowing
					# us to satisfy !instantDone
					josh.global_position = josh.global_position - OverworldVariables.transportFrom.global_position + get_node("Transporter/Enter/" + OverworldVariables.transportFrom.get_name()).global_position + adjust
					instantDone = 2

				# Otherwise have to press a button
				elif (!OverworldVariables.transportFrom.is_in_group("Instant")):
					if(Input.is_action_just_pressed("Action")):

						josh.global_position = josh.global_position - OverworldVariables.tranportFrom.global_position + get_node("Transporter/Enter/" + OverworldVariables.transportFrom.get_name()).global_position + adjust

						instantDone = 2
			# same but for enter
			elif (OverworldVariables.transportFrom.get_parent().get_name() == "Enter"):
				if (OverworldVariables.transportFrom.is_in_group("Instant") && !instantDone):
					josh.global_position = josh.global_position - OverworldVariables.transportFrom.global_position + get_node("Transporter/Exit/" + OverworldVariables.transportFrom.get_name()).global_position + adjust
					instantDone = 2

				elif (!OverworldVariables.transportFrom.is_in_group("Instant")):
					if(Input.is_action_just_pressed("Action")):
						josh.global_position = josh.global_position - OverworldVariables.transportFrom.global_position + get_node("Transporter/Exit/" + OverworldVariables.transportFrom.get_name()).global_position + adjust
						instantDone = 2
						

		elif (!OverworldVariables.canTransport && instantDone != 0):
			instantDone -= 1
		

			
	specialLogic()
			

func specialLogic():
	
	# switchCollisionAndLayers keeps us from running the code redundently.
	# we only want it run once when we enter either of them
	var switchCollisionAndLayers = false
	# If we're upstairs, there's no reason to check if we're downstairs too.
	if (get_node("Triggers and Logic/In Room").get_overlapping_areas().size() > 0):
		# if the code was already run before don't bother
		if (upstairs):
			switchCollisionAndLayers = true
		
		upstairs = false
		
	elif (get_node("Triggers and Logic/On Stairs").get_overlapping_areas().size() > 0):
		if (!upstairs):
			switchCollisionAndLayers = true
		
		upstairs = true
		
	# Go through and disable and enable every colision we need for the
	# appropriate position of josh, also sees if we should be able
	# to enter upstairs and if the layering of stairs and wall should
	# be visible
	if (upstairs && switchCollisionAndLayers):
		for i in range(get_node("Map/Living Room/Stairs 2").get_children().size()):
			get_node("Map/Living Room/Stairs 2/" + str(i)).disabled = true
		for i in range(get_node("Map/Living Room/Stairs 1").get_children().size()):
			get_node("Map/Living Room/Stairs 1/" + str(i)).disabled = false
		get_node("Transporter/Exit/Living Room/CollisionShape2D").disabled = false
		get_node("Objects/stairslayeringtrick").visible = false
		get_node("Triggers and Logic/Slope/CollisionShape2D").disabled = false
			
	elif (!upstairs && switchCollisionAndLayers):
		for i in range(get_node("Map/Living Room/Stairs 2").get_children().size()):
			get_node("Map/Living Room/Stairs 2/" + str(i)).disabled = false
		for i in range(get_node("Map/Living Room/Stairs 1").get_children().size()):
			get_node("Map/Living Room/Stairs 1/" + str(i)).disabled = true
		get_node("Transporter/Exit/Living Room/CollisionShape2D").disabled = true
		get_node("Objects/stairslayeringtrick").visible = true
		get_node("Triggers and Logic/Slope/CollisionShape2D").disabled = true
		
	
	# Slope Logic
	if (get_node("Triggers and Logic/Slope").get_overlapping_areas().size() > 0):
		if (josh.savedDirection.x < 0):
			josh.move_and_slide(Vector2(0, -josh.savedDirection.x / 2))
			
		if (josh.savedDirection.x > 0):
			josh.move_and_slide(Vector2(0, -josh.savedDirection.x / 2))
		

func loadTextBox():
	var textInstance = dialogueData.instance()
	# our text script is what stops us from walking, add anything besides 0 as another perameter
	# and we can walk while interacting
	textInstance.get_node("CanvasLayer/Label").newText("res://Dialogue/joshRoom.json", OverworldVariables.storedDialogue)
	add_child(textInstance)
