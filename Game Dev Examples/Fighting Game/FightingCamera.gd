extends Camera2D

# TODO: 


# * don't actually change the position of the camera until the end of the
#	frame for the script, so have a variable that we will add and subtract to
#	after which we'll simply assign the camera position to the variable in our clamp
#	at the bottom


# CHANGE LOG:
# * Implimented both the camera states, and also messed with the CLOSER state
#	so that the player and enemy don't push the camera before going into midpoint
#	state.

var josh = null
var enemy = null
var main = null
var goingToMidpoint = false
var playerEnemyDistance = 0
var leftWallExtents = 60	# change this if you want to tweek when
							# the midpoint calculations start
const SCREEN_WIDTH = 336
var rightWallExtents = GENERAL.RESOLUTION.x - leftWallExtents
const wallPadding = 30

enum cameraState {
	
	MIDPOINT,
	CLOSER

}

var currState = cameraState.MIDPOINT


func _ready():
	josh = get_node("../Players/Player")
	main = get_node("..")
	enemy = get_node("../Players/Enemy")
	# We'll eventually want to put this in the center of the map, not just the screen
	
	self.position = Vector2(336/2, 224/2)



func _physics_process(delta):
	
	# update these every frame, the current position (relative to the camera) of
	# both the player and enemy characters.
	var joshRelative = (josh.position.x - (self.position.x - GENERAL.RESOLUTION.x/2))
	var enemyRelative = (enemy.position.x - (self.position.x - GENERAL.RESOLUTION.x/2))
	
	
	# Not sure if needed, but just makes sure that we never ever move the camera
	# if both characters are on a wall, try not doing this check if new problems
	# with the camera happen.
	if ((joshRelative - wallPadding == 0 || joshRelative + wallPadding == GENERAL.RESOLUTION.x)
		&& (enemyRelative - wallPadding == 0 || enemyRelative + wallPadding == GENERAL.RESOLUTION.x)):
		pass
		
	else:
		match currState:
			cameraState.MIDPOINT:
	
				self.position.x = round((josh.position.x + enemy.position.x)/2)
				
	
				# if both aren't on the wall
				if ((!joshRelative <= leftWallExtents && !enemyRelative <= leftWallExtents) ||
					(!joshRelative >= rightWallExtents  && !enemyRelative >= rightWallExtents)):
					currState = cameraState.CLOSER
					
							
			cameraState.CLOSER:
	
				# We do the checking here as we don't want josh to do anything here if
				# both of these conditions are fit. If we don't do this Josh or the
				# enemy will push the camera a bit before midpoint happens, causing a 
				# jitter, which we don't want
				if ((joshRelative <= leftWallExtents || enemyRelative <= leftWallExtents) &&
					(joshRelative >= rightWallExtents || enemyRelative >= rightWallExtents)):
					
					currState = cameraState.MIDPOINT
					#goingToMidpoint = true
				#else:
					#goingToMidpoint = false
					
				
				# All the logic for pushing the camera in the direction you're moving
				# on the wall before both you and the enemy are at both extents and you enter
				# the midpoint.
				else:
					# we use an if and elif for these because in this state both shouldn't be able to
					# be true at once, otherwise it should be
					if (joshRelative <= leftWallExtents || enemyRelative <= leftWallExtents):
						if (joshRelative <= leftWallExtents):
							
							# subtracts from the position of the camera
							# the number of pixels that the player intersected
							# with the extents. So if my relative position is 58,
							# and the wallextents are 60, we will subtract 2 pixels
							# from the camera next frame.
							position.x -= leftWallExtents - joshRelative
						elif (enemyRelative <= leftWallExtents):
							#if (main.enemyVelocity.x < 0):
							position.x -= leftWallExtents - enemyRelative
							
					# PROOF IT'S POSSIBLE, JUST REPLACE 60 WITH OUR VARIABLE EXTENTS
					elif (joshRelative >= rightWallExtents || enemyRelative >= rightWallExtents):
						# if josh's position - (the camera position - the other half of the screen)
						# is >= the right side of the screen - the extents
						if (joshRelative >= rightWallExtents):
							#if (main.joshVelocity.x > 0):
								#position.x += (main.joshVelocity.x - 60) * delta
							#	print((josh.position.x - (self.position.x - 336/2)) - (336 -60))
							position.x += joshRelative - rightWallExtents
	
						elif (enemyRelative >= rightWallExtents):
						#	if (main.enemyVelocity.x > 0):
							position.x += enemyRelative - rightWallExtents
							# right now this is being done to test out the sack
							# pushing on the barrier too, there really is no
							# enemy velocity yet and we're just using the pushing
							# logic in the main script to do this.


	# Eventually when we want to start this scene from the overworld
	# we want to specify the extents with constants like
	# "BIG ROOM", "CRAMPED", "MEDIUM" to make for some more dynamic matches
	self.position.x = clamp(position.x, 168, 350)
