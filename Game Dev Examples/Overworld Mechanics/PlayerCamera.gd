extends Camera2D

# TODO: 

# *	DON'T BASE IT OFF OF THE RECTANGLE AREA2D, MAKE IT BASED ON A BIG
# 	RADIUS ON JOSH, AND A RADIUS ON THE ENEMY, REALLY DANGEROUS ONES CAN
# 	HAVE A BIGGER RADIUS, THIS WILL MAKE THINGS A LOT BETTER
#	UPDATE: DONE

# * Fix things up when in the fight mode so that there aren't teleports when
#	going to another quarter, this is important to fix.
#	UPDATE: FIXED by making sure both conditions for tranX and tranY are 
#	met on the same frame, so if one is right on the midpoint in that frame
#	it won't do anything, but it might be able to next frame since both
#	positions for the midpoint can move, we can't assume it'll just be
#	done when it's done like when it only has to deal with getting in the
#	middle of Josh.

# * Clean all this up, up there's so much redundent stuff like having
#	the variable transition when having tranX and Y invalidates it's existence.

# A script for the different camera states.
var cameraBox = null

enum state { CENTERED, FIGHT, FIXED }
var cameraState = state.CENTERED
const moveSpeed = 30
var transition = true
var tranX = false
var tranY = false

enum moveY { MORE, LESS, NONE }
var movingY
enum moveX { MORE, LESS, NONE }
var movingX

var numOfEnemies = 0
var playerYOffset = Vector2(0,0)	# displace the z axis so it's more around the center
					# of the characters instead of their feet
var pos = Vector2(0, 0)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	playerYOffset = get_node("../Animation").offset
	cameraBox = get_node("../View")

func _physics_process(delta):
	
	match cameraState:
		
		state.FIXED:
			self.global_position = pos
		
		state.CENTERED:
			
			if (cameraBox.get_overlapping_areas().size() > 0):
				#print(cameraBox.get_overlapping_bodies()[0].get_name())
				
				cameraState = state.FIGHT
				transition = true
				tranX = true
				tranY = true
				numOfEnemies = cameraBox.get_overlapping_areas().size()
				
				var meanAdder = Vector2(0, 0)
				for i in range(cameraBox.get_overlapping_areas().size()):
					meanAdder += cameraBox.get_overlapping_areas()[i].global_position
					# accounts for their offset
					meanAdder += get_node("../../" + cameraBox.get_overlapping_areas()[0].get_parent().get_name() + "/Animation").offset
					#meanAdder.y +=

				# Add 1 in the divider to represent Josh
				var meanDivider = 1/ float((cameraBox.get_overlapping_areas().size() + 1))
	

				var midpoint = (meanAdder + (get_node("..").global_position + playerYOffset)) * meanDivider
				
				if (round(self.global_position.x) > round(midpoint.x)):
					movingX = moveX.LESS
				elif (round(self.global_position.x) < round(midpoint.x)):
					movingX = moveX.MORE
				else:
					movingX = moveX.NONE
					
				if (round(self.global_position.y) > round(midpoint.y)):
					movingY = moveY.LESS
				elif (round(self.global_position.y) < round(midpoint.y)):
					movingY = moveY.MORE
				else:
					movingY = moveY.NONE
					
					
			else:
				
				var centered = get_node("..").global_position
				centered += playerYOffset
					
					# go one pixel at a time every frame to the destination
				if (tranX || tranY):
						
						
					self.global_position = transition(delta, self.global_position, centered)
						
	
				# after we reach the destination, just keep the camera centered
				# on josh every frame.
				else:
					self.global_position = centered


			
				
		state.FIGHT:
			
			if (cameraBox.get_overlapping_areas().size() == 0):

				cameraState = state.CENTERED
				transition = true
				tranX = true
				tranY = true
				numOfEnemies = 0
				var centered = get_node("..").global_position
				centered += playerYOffset
				
				if (round(self.global_position.x) > centered.x):
					movingX = moveX.LESS
				elif (round(self.global_position.x) < centered.x):
					movingX = moveX.MORE
				else:
					movingX = moveX.NONE
				if (round(self.global_position.y) > centered.y):
					movingY = moveY.LESS
				elif (round(self.global_position.y) < centered.y):
					movingY = moveY.MORE	
				else:
					movingY = moveY.NONE
			else:
			
				# eventually get this working with multiple enemies. Use the size
				# of the overlapping bodies to calculate the mean instead of just doing 0.5
		
				var meanAdder = Vector2(0, 0)
				for i in range(cameraBox.get_overlapping_areas().size()):
					meanAdder += cameraBox.get_overlapping_areas()[i].global_position
					# accounts for their offset
					meanAdder += get_node("../../" + cameraBox.get_overlapping_areas()[i].get_parent().get_name() + "/Animation").offset
					#meanAdder.y +=

				# Add 1 in the divider to represent Josh
				var meanDivider = 1/ float((cameraBox.get_overlapping_areas().size() + 1))
	

				var midpoint = (meanAdder + (get_node("..").global_position + playerYOffset)) * meanDivider

				
				#self.global_position = (get_node("../../").position + get_node("..").position) * 0.5
	
				
	
				if (tranX || tranY):
					
					# new enemies could enter into the fray while the transition happens
					if (numOfEnemies != cameraBox.get_overlapping_areas().size()):
						enemyChangeTransition(midpoint)
						
					self.global_position = transition(delta, self.global_position, midpoint)
							
				else:
					
					# if we have a new enemy, transition to the new midpoint
					if (numOfEnemies != cameraBox.get_overlapping_areas().size()):
						enemyChangeTransition(midpoint)
					else:
						self.global_position = midpoint
					
			

					


func transition(delta, cameraPosition, destination):

	# because the midpoint can change every frame, just
	# because one dimension might be done on one frame 
	# doesn't mean it will be done next if one of the
	# characters moves, so make sure BOTH are false
	# on the same frame before going into the midpoint.
	tranX = true
	tranY = true
	



	match movingX:

		moveX.LESS:

			cameraPosition.x -= moveSpeed * delta
			if (round(cameraPosition.x) <= round(destination.x)):
				cameraPosition.x = destination.x

		moveX.MORE:

			cameraPosition.x += moveSpeed * delta
			if (round(cameraPosition.x) >= round(destination.x)):
				cameraPosition.x = destination.x

	match movingY:

		moveY.LESS:

			cameraPosition.y -= moveSpeed * delta
			if (round(cameraPosition.y) <= round(destination.y)):
				cameraPosition.y = destination.y

		moveY.MORE:

			cameraPosition.y += moveSpeed * delta
			if (round(cameraPosition.y) >= round(destination.y)):
				cameraPosition.y = destination.y
				
				
	if (round(cameraPosition.x) > round(destination.x)):
		movingX = moveX.LESS
	elif (round(cameraPosition.x) < round(destination.x)):
		movingX = moveX.MORE
	else:
		tranX = false

	if (round(cameraPosition.y) > round(destination.y)):
		movingY = moveY.LESS
	elif (round(cameraPosition.y) < round(destination.y)):
		movingY = moveY.MORE
	else:
		tranY = false	
		
		
	return cameraPosition
		
func enemyChangeTransition(midpoint):
	tranX = true
	tranY = true
	# make the new normal
	numOfEnemies = cameraBox.get_overlapping_areas().size()
	
	if (round(self.global_position.x) > round(midpoint.x)):
		movingX = moveX.LESS
	elif (round(self.global_position.x) < round(midpoint.x)):
		movingX = moveX.MORE
	else:
		movingX = moveX.NONE
		
	if (round(self.global_position.y) > round(midpoint.y)):
		movingY = moveY.LESS
	elif (round(self.global_position.y) < round(midpoint.y)):
		movingY = moveY.MORE
	else:
		movingY = moveY.NONE


	




		


