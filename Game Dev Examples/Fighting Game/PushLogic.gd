extends Node

# TODO:
	
	# * Let's clean up the code so it isn't as repetitive, like constant checking
	#	for if we're flipped or not, do it once, and have all the actions with that one.
	

var camera = null
var enemy = null
var josh = null

var joshPushBoxW = 0
var enemyPushBoxW = 0
var wallPadding = 30
var enemyFlipped = false


func _ready():
	camera = get_node("../Camera2D")
	enemy = get_node("../Players/Enemy")
	josh = get_node("../Players/Player")




func _physics_process(delta):

	# update these every frame in case they change size
	joshPushBoxW = get_node("../Players/Player").pushBoxW
	enemyPushBoxW = get_node("../Players/Enemy").pushBoxW

	if (josh.position.x < enemy.position.x):
		enemyFlipped = false
	else:
		enemyFlipped = true

	if (get_node("../Players/Player/pushBox").pushChecking):
		checkForPushing()
		
# Does all of our collision checking with the push boxes.
func checkForPushing():
	
	# ALGORITHMS FOR FUTURE:
		# TO GET THE CLIPPING WORKING FOR BOTH CHARACTER'S WE'LL USE THIS ALGORITHM:
		#	if (character.injumpstate or enemy.injumpstate):
		#		if (character.injumpstate):
		#			*block of code to push them out depending on position they hit
		#		elif (enemy.injumpstate):
		#			*block of code to push them out
		
		#ACTUALLY DON'T EVEN DO THE SHIT WITH THE STATE, JUST HAVE THE PRIORITY
		#OF WHO'S PUSHING WHO BE BASED ON THE Y-POSITION OF THE TWO BODIES IF ONE IS
		#HIGHER THAN THE OTHER THAN THEY TELEPORT THE OTHER GUY
	
	
		# has an interesting effect, as even when we are in the pushbox, it
		# won't push unless we move forward (obviously it should be the oposite
		# when everything is flipped)
		# WHY WE ONLY CHECK AND MOVE X:
		#	imagine that we also checked and moved the y value too, we do a jump
		#	into the the enemy, they start falling with our vertical velocity and
		#	go through the floor, so we only want the horizontal one assigned and checked

	# -----------------------------------------------
	# PUSHING BOXES
	# -----------------------------------------------

	# This bit of code will determine if the enemy or the player should be pushed
	# probably change this to only test to see if josh is on the right or left, checking for
	# somebody being flipped could get ugly.
	if (!enemyFlipped):
		# Josh is moving forwards
		if (josh.velocity.x > 0):
			
			# if the enemy is retreeting but we continue to outspeed them,
			# we push them with josh's velocity, not even taking into account their
			# velocity
			if (enemy.velocity.x > 0 && josh.velocity.x > enemy.velocity.x):

				# since we already moved the enemy before the pushCheck, we don't want to add to that, we just
				# want to have it the same velocity and josh, so we just subtrack the previous enemyVelocity so it just works with josh
				enemy.move_and_slide(Vector2(josh.velocity.x - enemy.velocity.x, 0))
				enemy.position.x = clamp(enemy.position.x, camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)
	
			else:
				# move the enemy in the same velocity as josh.
				enemy.move_and_slide(Vector2(josh.velocity.x, 0))
				# make sure they stay within bounds.
				enemy.position.x = clamp(enemy.position.x, camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)
				
		# Enemy is pushing against josh
		if (enemy.velocity.x < 0):
			# josh is retreating but the enemy is faster
			if (josh.velocity.x < 0 && enemy.velocity.x < josh.velocity.x):
				
				josh.move_and_slide(Vector2(enemy.velocity.x - josh.velocity.x, 0))
				josh.position.x = clamp(josh.position.x, camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)
				
			else:
				# move josh with the velocity of the enemy, since he is faster he still
				# moves forward, and pushes the enemy, although at a slower speed.
				josh.move_and_slide(Vector2(enemy.velocity.x, 0))
				josh.position.x = clamp(josh.position.x, camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)
			

	# same thing again, just for when things are flipped
	else:
		# if josh is moving forward
		if (josh.velocity.x < 0):

			if (enemy.velocity.x < 0 && josh.velocity.x < enemy.velocity.x):

				# since we already moved the enemy before the pushCheck, we don't want to add to that, we just
				# want to have it the same velocity and josh, so we just subtrack the previous enemyVelocity so it just works with josh
				enemy.move_and_slide(Vector2(josh.velocity.x - enemy.velocity.x, 0))
				enemy.position.x = clamp(enemy.position.x, camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)

			else:
				enemy.move_and_slide(Vector2(josh.velocity.x, 0))
				enemy.position.x = clamp(enemy.position.x, camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)
				#print(true)
		
		# if the enemy is moving forward
		if (enemy.velocity.x > 0):
			
			# josh is running away from the enemy, the enemy catches up and pushes him.
			if (josh.velocity.x > 0 && enemy.velocity.x > josh.velocity.x):


				josh.move_and_slide(Vector2(enemy.velocity.x - josh.velocity.x, 0))
				josh.position.x = clamp(josh.position.x, camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)
				
			# a normal head on collision
			else:
				josh.move_and_slide(Vector2(enemy.velocity.x, 0))
				josh.position.x = clamp(josh.position.x, camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)


	# WAIT, I'M REALISING THAT THE CODE FOR THIS ISN'T EVEN NEEDED BECAUSE
	# THE GAME IS ALREADY CHECKING ABLE TO DO COLLISION CHECKS VERTICALLY
	# AUTOMATICALLY, AND  WE ALREADY HAVE OUR "COMPLETE RESET IF CHARACTERS ARE TOO IN EACH OTHER'S BOXES"
	# SECTION THAT ALREADY DOES THIS EXACT CODE, WITHOUT NEEDING ANY
	# EXTRA VARIABLES. JUST CHANGE IT SO THAT THE PRIORITY OF WHO IS RESET
	# IS BASED OFF OF WHO IS HIGHER VERTICALLY OFF THE GROUND,
	# THIS WILL MAKE IT WORK EXACTLY HOW WE WANT.
	# -----------------------------------------------
	# RESETTING WHEN JUMPED ON
	# -----------------------------------------------

	# NOTE: WHEN WE GET THE ENEMY JUMPING, WE WANT THIS RESET BASED OFF OF WHO IS HIGHER IN THE AIR

	# this if/else block makes sure josh never ends up in the box
	# it is subtracting 36, twice our current extents- the first half puts the center of
	# out character off, but needs another 18 to componsate for the extents of the players
	# hitbox also. meaning eventually we want to subtract (player.extents + enemy.extents)
#	if (josh.position.y + 31 < enemy.position.y - 21 + 20): #&& abs(enemy.position.x - 36 = josh.position.x + 36) > 36:
#		if (!enemyFlipped):
#			print("works")
#			enemy.position.x = clamp(josh.position.x + (joshPushBoxW + enemyPushBoxW), get_node("Camera2D").position.x - (336/2) + wallPadding, get_node("Camera2D").position.x + (336/2) - wallPadding)
#			josh.position.x = clamp(enemy.position.x - (joshPushBoxW + enemyPushBoxW), get_node("Camera2D").position.x - (336/2) + wallPadding, get_node("Camera2D").position.x + (336/2) - wallPadding)
#
#		else:
#
#			enemy.position.x = clamp(josh.position.x - (joshPushBoxW + enemyPushBoxW), get_node("Camera2D").position.x - (336/2) + wallPadding, get_node("Camera2D").position.x + (336/2) - wallPadding)
#			josh.position.x = clamp(enemy.position.x + (joshPushBoxW + enemyPushBoxW), get_node("Camera2D").position.x - (336/2) + wallPadding, get_node("Camera2D").position.x + (336/2) - wallPadding)
#						#enemy.position.x = josh.position.x - 36
#

		

		
	
	# -----------------------------------------------
	# KEEPING CHARACTERS IN BOUNDS WHEN UP AGAINST A WALL,
	# AND RESETTING LOGIC IS CHANGED SLIGHTLY
	# -----------------------------------------------

	# if on wall. resets everybody outside the pushbox.
	
	# enemy on the right wall
	# PUT CLAMPS ON THESE
	# 318 is from the edge of the screen on the right (336), minus the hitbox size (18)
	if (enemy.position.x - (camera.position.x - 336/2) >= 336 - wallPadding):
		# if we attempt to enter the box further, there's no reason to reset
		# when josh isn't even moving.
		if (josh.velocity.x > 0):
			josh.position.x = clamp(enemy.position.x - (joshPushBoxW + enemyPushBoxW), camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)
	# enemy on the left wall
	elif (enemy.position.x - (camera.position.x - 336/2) <= wallPadding):
		if (josh.velocity.x < 0):
			josh.position.x = clamp(enemy.position.x + (joshPushBoxW + enemyPushBoxW), camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)
	# player on the left wall
	elif (josh.position.x - (camera.position.x - 336/2) <= wallPadding):
		if (enemy.velocity.x < 0):

			enemy.position.x = clamp(josh.position.x + (joshPushBoxW + enemyPushBoxW), camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)

	# player on the right wall
	elif (josh.position.x - (camera.position.x - 336/2) >= 336 - wallPadding):

		if (enemy.velocity.x > 0):

			enemy.position.x = clamp(josh.position.x - (joshPushBoxW + enemyPushBoxW), camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)

	
	# -----------------------------------------------
	# COMPLETE RESET IF CHARACTERS ARE TOO IN EACH OTHER'S BOXES
	# -----------------------------------------------
		
	# if when we come back to this we want to go above and behond with preventing
	# any collisions we can do something like this, come up with an easy way to
	# make this work for flipped and with both characters, and come up with a 
	# priority for who will push who out.
	if ((abs(josh.position.x - enemy.position.x)) < (joshPushBoxW + enemyPushBoxW)):
		
		var joshHeight = round(josh.position.y + get_node("../Players/Player/Collision").position.y)
		var enemyHeight = round(enemy.position.y + get_node("../Players/Enemy/Collision").position.y)
		
		
		# if they are the same height and are simply in each other do
		# to hitting each other at a faster velocity, the reset priority
		# goes to the faster character on the frame
		if (joshHeight == enemyHeight):
			# josh is faster, we don't care about if it's faster in the negative
			# or positive direction, so we use the absolute value to determine
			# who is simply moving quicker
			if (abs(josh.velocity.x) >= abs(enemy.velocity.x)):
				if (!enemyFlipped):
					enemy.position.x = clamp(josh.position.x + (joshPushBoxW + enemyPushBoxW), camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)
					josh.position.x = clamp(enemy.position.x - (joshPushBoxW + enemyPushBoxW), camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)
				else:
					enemy.position.x = clamp(josh.position.x - (joshPushBoxW + enemyPushBoxW), camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)
					josh.position.x = clamp(enemy.position.x + (joshPushBoxW + enemyPushBoxW), camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)	
			
			# enemy is faster
			else:
				if (!enemyFlipped):
					josh.position.x = clamp(enemy.position.x - (joshPushBoxW + enemyPushBoxW), camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)
					enemy.position.x = clamp(josh.position.x + (joshPushBoxW + enemyPushBoxW), camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)
				else:
					josh.position.x = clamp(enemy.position.x + (joshPushBoxW + enemyPushBoxW), camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)
					enemy.position.x = clamp(josh.position.x - (joshPushBoxW + enemyPushBoxW), camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)
	
		
		# if they aren't at the same height, we give priority of the reset
		# to the character that is higher up, this means characters who are
		# on top of the other will reset the character on the ground, unless
		# they are stuck on the ground
		else:
			# if josh is higher up
			if (joshHeight < enemyHeight):
	
				if (!enemyFlipped):
					enemy.position.x = clamp(josh.position.x + (joshPushBoxW + enemyPushBoxW), camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)
					josh.position.x = clamp(enemy.position.x - (joshPushBoxW + enemyPushBoxW), camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)
				else:
					enemy.position.x = clamp(josh.position.x - (joshPushBoxW + enemyPushBoxW), camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)
					josh.position.x = clamp(enemy.position.x + (joshPushBoxW + enemyPushBoxW), camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)	
			# enemy is higher up
			else:
				if (!enemyFlipped):
					josh.position.x = clamp(enemy.position.x - (joshPushBoxW + enemyPushBoxW), camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)
					enemy.position.x = clamp(josh.position.x + (joshPushBoxW + enemyPushBoxW), camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)
				else:
					josh.position.x = clamp(enemy.position.x + (joshPushBoxW + enemyPushBoxW), camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)
					enemy.position.x = clamp(josh.position.x - (joshPushBoxW + enemyPushBoxW), camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding)

	
	
	
	
