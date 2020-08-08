extends KinematicBody2D

#	Move_and_Collide and move_and_slide are only different because move_and_slide
#	already has delta built into it, whereas move_and_collide has to have it added manually 

# Some things to maybe make josh complete:
	
	# * ADD LOCK ON

	# * find a away to get it so a body isn't interacting with objects, but our raycast2D
	#	instead
	# * add a function that allows us to impliment our algorithm for pathfinding in
	#	case we want josh to be able to further interact with things
	# * add a function that will allow josh to go up inclines and stairs so our
	#	game feels more 3D
	# * if we have time, a bit of a buffer so you don't need to let go of both keys at the
	#	same time for josh to idle at a diagonal direction
	# (THE BOTTOM TWO SHOULDN'T BE DONE HERE AND SHOULD INSTEAD BE DONE IN OUR 
	# GLOBAL OVERWORLD VARIABLES)
	# * have a global position variable that can be menipulated so that you end up
	# 	in the appropriate location in the next scene after exiting the previous one
	# * (all we'd have to do with this is have the position we're suppose to be at
	#	when we go enter the area2D that takes us to the next area stored as a 
	#	global overworld vairable that we'll use to position josh on load.

# CHANGELOG:
	# * We made a movement history array that tracks what we've been doing
	#	the last 10 frames, we're using this to make josh get a running
	#	start when he runs, and will later code in something that makes it so
	#	josh can stop at an angle easier (probably by giving the walking some input lag
	#	and determining it from that)
	#	NOTE: You might also just be able to do this by having a variable that counts
	#	to 10 every frame we have Z held down, and once it reaches 10 activates the run
	#	and reset it to zero once it's off the button
	# * we got it so josh will now stop when he interacts with an object, as well
	#	as all the stuff already talked about in the martha animation scene script.


var joshPosition = Vector2(0, 0)
var areaTest = false
var dialogueTree = ""
var dialogueData = preload("res://Scenes/General/Text Box/TextBubbles.tscn")
var previousAni = ""
var action = ""
enum state { IDLE, RUNNING, WALKING }

var currState = state.IDLE
var movementHistory = []
var rayCast = null
var cameraBox = null
var enemies = []
var leniency = 15
var lockedOn = false
var savedDirection = Vector2()


func _ready():

	#OS.window_size = GENERAL.RESOLUTION * 3
	Engine.target_fps = 60
	cameraBox = get_node("View")



func _physics_process(delta):
	
	rayCast = get_node("RayCast2D")
	cameraBox = get_node("View")


	
	#print(AudioServer.get_bus_volume_db(0))


	# switched to doing it like this for the rayCast, sadly area2d signals don't
	# really work so we have to check every frame here, maybe put this in it's own
	# function for cleaness and try to think about how to optimize it a little so
	# we don't need to check every frame.
	if (rayCast.is_colliding()):
		OverworldVariables.isInteractible = true
		# it says storedDialogue but it's really any interactible 
		OverworldVariables.storedDialogue = rayCast.get_collider().get_name()


	else:
		OverworldVariables.isInteractible = false
		OverworldVariables.storedDialogue = null
	#print(tileMap.get_cellv(tileMap.world_to_map(self.position + get_node("RayCast2D").cast_to)))
	
	OverworldVariables.transportFrom = null
	OverworldVariables.canTransport = false
	if (get_node("Box").get_overlapping_areas().size() > 0):
#
#		OverworldVariables.transportFrom = get_node("Box").get_overlapping_areas()[0]
#		OverworldVariables.canTransport = true
#
#	else:
#		OverworldVariables.transportFrom = null
#		OverworldVariables.canTransport = false

		if (get_node("Box").get_overlapping_areas().size() > 0):
			for i in range(get_node("Box").get_overlapping_areas().size()):
				if (get_node("Box").get_overlapping_areas()[i].is_in_group("Transport")):
					OverworldVariables.transportFrom = get_node("Box").get_overlapping_areas()[i]
					OverworldVariables.canTransport = true

		
	if (OverworldVariables.canWalk):
		
		# MAYBE ADD OUR CONDITIONS ABOVE IN HERE SO THE CODE DOESN'T RUN
		# WHEN FIGHTS OR DIALOGUE HAPPEN

		movement(delta)
	# when we enter a cutscene, put us in idle if we are walking or running
	else:
		if (currState != state.IDLE):
			get_node("Animation").play("I" + previousAni)
			get_node("Animation").frame = 0
#
#	# AND if dialogue box is not already opened
#	if (inInteractible && OverworldVariables.canWalk):
#		if (Input.is_action_just_pressed("Action")):
#			#get_tree().change_scene("res://FGControls.tscn")
#			OverworldVariables.canWalk = false	#why things won't push us
#			get_node("../../Cutscene/AnimationPlayer").play("signAni1")
			

			
		

func movement(delta):
	
	var inputOut = ""

	var speed = 120
	var ani = get_node("Animation")
	var get_frame = ani.frame
	var rayCastPos = get_node("RayCast2D")
	var direction = Vector2()
	
	
	match currState:
		

		state.IDLE:
			
			savedDirection = Vector2(0, 0)

			if (Input.is_action_pressed("Up") || 
			Input.is_action_pressed("Down") || 
			Input.is_action_pressed("Left") || 
			Input.is_action_pressed("Right")):

				currState = state.WALKING
				
			if (lockedOn):
				
				var closeEnemy = enemies[0].location
				
				# look at closest enemy
				if (Input.is_action_pressed("Create")):
					
					# Eventually get if's and all that for walking or running
					# towards enemy, as well as punches
					var face = "I"
					rayCastPos.cast_to = Vector2(0, 0)
					
					if (self.position.y - leniency < closeEnemy.position.y && 
					self.position.y + leniency > closeEnemy.position.y):
						pass
					
					elif (self.position.y < closeEnemy.position.y):
						face += "Down"
						rayCastPos.cast_to.y += 10
				
					elif (self.position.y >= closeEnemy.position.y):
						face += "Up"
						rayCastPos.cast_to.y -= 10
					
					if (self.position.x - leniency < closeEnemy.position.x && 
						self.position.x + leniency > closeEnemy.position.x):
							pass
							
					elif (self.position.x > closeEnemy.position.x):
						face += "Left"
						rayCastPos.cast_to.x -= 10
					elif (self.position.x <= closeEnemy.position.x):
						face += "Right"
						rayCastPos.cast_to.x += 10
						
					ani.animation = face

					
				else:
					enemies.clear()
					lockedOn = false

					
		state.WALKING:


			var previousPos = self.position
			
			
			
			if (Input.is_action_pressed("Up")):
				
				inputOut = "Up"
				rayCastPos.cast_to = Vector2(0, -10)
				ani.offset = Vector2(0, -20)
				
				if (Input.is_action_pressed("Right")):
					ani.offset = Vector2(-2, -20)
					direction = Vector2(1, -1)
					rayCastPos.cast_to = Vector2(10, -10)
					inputOut = "UpRight"
				elif (Input.is_action_pressed("Left")):
					ani.offset = Vector2(0, -20)
					direction = Vector2(-1, -1)
					rayCastPos.cast_to = Vector2(-10, -10)
					inputOut = "UpLeft"
				else:
					direction = Vector2(0, -1)
					
			elif (Input.is_action_pressed("Right")):
				
				
				ani.offset = Vector2(-2, -20)
				inputOut = "Right"
				rayCastPos.cast_to = Vector2(10, 0)
				
				if (Input.is_action_pressed("Up")):
					direction = Vector2(1, -1)
					rayCastPos.cast_to = Vector2(10, -10)
					inputOut = "UpRight"
				elif (Input.is_action_pressed("Down")):
					direction = Vector2(1, 1)
					rayCastPos.cast_to = Vector2(10, 10)
					inputOut = "DownRight"
				else:
					direction = Vector2(1, 0)
					
			elif (Input.is_action_pressed("Down")):
				
				inputOut = "Down"
				rayCastPos.cast_to = Vector2(0, 10)
				ani.offset = Vector2(0, -20)
				
				if (Input.is_action_pressed("Right")):
					direction = Vector2(1, 1)
					rayCastPos.cast_to = Vector2(10, 10)
					inputOut = "DownRight"
					ani.offset = Vector2(-2, -20)
				elif (Input.is_action_pressed("Left")):
					direction = Vector2(-1, 1)
					rayCastPos.cast_to = Vector2(-10, 10)
					inputOut = "DownLeft"
					ani.offset = Vector2(0, -20)
				else:
					direction = Vector2(0, 1)
			elif (Input.is_action_pressed("Left")):
				
				inputOut = "Left"
				rayCastPos.cast_to = Vector2(-10, 0)
				ani.offset = Vector2(0, -20)
				
				if (Input.is_action_pressed("Up")):
					direction = Vector2(-1, -1)
					rayCastPos.cast_to = Vector2(-10, -10)
					inputOut = "UpLeft"
					ani.offset = Vector2(0, -20)
				elif (Input.is_action_pressed("Down")):
					direction = Vector2(-1, 1)
					rayCastPos.cast_to = Vector2(-10, 10)
					inputOut = "DownLeft"
					ani.offset = Vector2(0, -20)
				else:
					direction = Vector2(-1, 0)
					
			else:
				currState = state.IDLE
				ani.play("I" + previousAni)
				movementHistory.clear()
				
			
						
				
			if (currState != state.IDLE):
				
				if (lockedOn):
					var closeEnemy = enemies[0].location

					
					# look at closest enemy
					if (Input.is_action_pressed("Create")):
						
						inputOut = ""
						rayCastPos.cast_to = Vector2(0, 0)
						
						# Eventually get if's and all that for walking or running
						# towards enemy, as well as punches
						if (self.position.y - leniency < closeEnemy.position.y && 
						self.position.y + leniency > closeEnemy.position.y):
							pass

						
						elif (self.position.y < closeEnemy.position.y):
							inputOut += "Down"
							rayCastPos.cast_to.y += 10
					
						elif (self.position.y >= closeEnemy.position.y):
							inputOut += "Up"
							rayCastPos.cast_to.y -= 10
						
						if (self.position.x - leniency < closeEnemy.position.x && 
							self.position.x + leniency > closeEnemy.position.x):
								pass
								
						elif (self.position.x > closeEnemy.position.x):
							inputOut += "Left"
							rayCastPos.cast_to.x -= 10
						elif (self.position.x <= closeEnemy.position.x):
							inputOut += "Right"
							rayCastPos.cast_to.x += 10
							
					else:
						enemies.clear()
						lockedOn = false

				# Append our movement history
				if (Input.is_action_pressed("Action")):
					movementHistory.append("R" + inputOut)

				else:
					movementHistory.append("W" + inputOut)
				

				# if we have 10 inputs already
				if (movementHistory.size() >= 10):
					# if we have run in the last 10 frames, and we're still on the button
					if (movementHistory[movementHistory.size() - 10][0] == 'R' && Input.is_action_pressed("Action")):
						# Josh will run
						ani.play("R" + inputOut)
						speed = 180
						
					# otherwise he walks
					else:
						ani.play("W" + inputOut)
						# to make sure we can't just tap to restart the run
						# instantly after stopping it
						movementHistory.clear()

					
				# he should walk even if he doesn't have those 10 inputs.
				else:
					ani.play("W" + inputOut)




				ani.frame = get_frame
				
				direction *= speed
				
				move_and_slide(direction)
				savedDirection = direction

				# integer rounding
				self.position = Vector2(round(position.x), round(position.y))
				# sub pixel (choose one)
				self.position = Vector2(position.x, position.y)
				# hit wall
				if (previousPos == self.position):
					currState = state.IDLE
					ani.play("I" + inputOut)
					movementHistory.clear()
	
	
				previousPos = self.position
				previousAni = inputOut


	# Lock On
	if (cameraBox.get_overlapping_areas().size() > 0):
		if (Input.is_action_just_pressed("Create") && !lockedOn):
			for i in range(cameraBox.get_overlapping_areas().size()):
				var distance = 0
				print(true)
				var enemy = get_node("../" + cameraBox.get_overlapping_areas()[i].get_parent().get_name())
				# distance formula
				distance = sqrt(pow(self.position.x - enemy.position.x, 2) +
								pow(self.position.y - enemy.position.y, 2))
										

				enemies.append({length = distance, location = get_node("../" + cameraBox.get_overlapping_areas()[i].get_parent().get_name()) })
			enemySorting(enemies)
			lockedOn = true
	else:
		lockedOn = false
		

			

			#currState = state.LOCK_ON
		
					


	# if our movementhistory is above 10, replace the oldest one with
	# the one after it to make room for the new input
	if (movementHistory.size() > 10):
		movementHistory.pop_front()



	
	# We need to make sprites for martha of her running, when we do this, we can
	# have them be the same as above but with "Run" added after, this is a simple
	# way of getting her running without much code
	# if (Input.is_action_pressed("Run")):
	#	inputOut += "Run"
	#	speed *= 2
		

	


	#translate(direction)
	#move_and_collide(direction)
	#inputOut = action + inputOut
	#marthaSprite.play(inputOut)
	#marthaSprite.frame = get_frame

	
#
#func areaEntered(area, areaName):
#	print(area.get_name())
#	if (area.get_name() == "Josh"):
#
#		OverworldVariables.isInteractible = true
#		OverworldVariables.storedDialogue = areaName


# If we only want the smallest one we could customize this so that
# we sort it from greatest to least, because then the smallest one will
# be at the end in only one pass, making this insanely efficient.
# then we just call array[sizeOfArray-1] to get it
func enemySorting(enemyInfo):
	var n = enemyInfo.size()
	var swap = true
	while (swap):
		swap = false
		for i in range(1, n):
			if (enemyInfo[i].length < enemyInfo[i-1].length):
				var temp = enemyInfo[i-1]
				enemyInfo[i-1] = enemyInfo[i]
				enemyInfo[i] = temp
				swap = true
		n -= 1
 
			
	
		
