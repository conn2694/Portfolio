extends Node

# TODO:
	
	# * DON'T FLUSH THE INPUT RIGHT AFTER IT IS DONE! 
	#	We want to instead flush the inputs once a move is actually done
	#	the issue with flushing right after is that if we are in the
	#	middle of a combo and want to buffer our next move, it will delete
	#	it immediately and we won't be able to do the move.
	#	Flushing instead in the character script after a move is actually
	#	done would be much better
	
	# * Can you cancel a crouch on frame one if it isn't in the crouched
	#	state yet or is it just really fast to get to that state in most
	#	fighting games? find out the difference so we can know, we want 
	#	teabagging.
	
	
	# * Let's make the inputs more general things like QCF and just
	#	gestures we would want to be able to have the player do
	#	that the game registers and we can feed to josh, then with that
	#	info, we use that in the player scene to decide what move to do
	#	based on what state.
	
	# * We need to change some stuff with inputs period, first off we
	#	probably don't need the inputLag anymore since charge moves
	#	won't be in the game. Second off when we want to reset
	#	the inputs from inactivity make sure that when we do that
	#	it immediately puts in what we're currently holding (we might
	#	already have this, but make sure it's there, we don't want a player
	#	to go from a crouch to a fireball and have the down button not register
	#	because they were staying in the crouch for awhile). Also
	#	fix up how we do enter the input to go into Josh's states. Maybe
	#	have a variable and we have it be the input based on
	#	size (if there is anything in the pool), and if there isn't we just
	#	use a null input, like for when we aren't inputting anything and use
	#	that.
	
	# * We need two different variables for moves, we need one value
	#	for how much the enemy will be pushed away when they get hit on
	#	the ground, and also one for when they get hit in the air. All moves
	#	except moves that launch them up should probably give the same amount
	#	of vertical velocity and most should have the same horizontal too, but
	#	just have that variable so we can specialize things.
	


	
	# * Use our hitbox logic to confirm that a move was a hit, and then
	#	on the stop logic, the player can buffer the cancel into another move
	#	just an idea as to how we could do it.
	#	EDIT: This article describes how freezeframe relates to cancels
	#	https://critpoints.net/2017/05/17/hitstophitfreezehitlaghitpausehitshit/
	#	Basically we can say that the player has until the recovery frames start
	#	to cancel the move into something else, and the freeze stop just makes
	#	it easier since you have more frames. We need two conditions met, the
	#	input for the move that can be cancelled into needs to be done before
	#	the recovery frames, but you also need to have hit the apponent either
	#	on block or on hit to cancel, and if you're in freeze frame, you need
	#	to wait until that is done before the cancel can happen and the 
	#	inputs get reset

	#
	# * It honestly might be time to move the logic with inputs into
	#	the scene with the actual character, it seems like it makes the
	#	most sense logically, and the only character who really needs
	#	our inputs in Josh (since we don't want to write AI that reads
	#	our inputs). Give it some thought after getting all the logic done
	#	for hitboxes and freeze frames, we can just use this script
	#	for documentation if we do that.
	#
	# * an issue right now with the pausing is that it only pauses the animation
	#	but does not prevent the player from entering new states or playing
	#	other animations from inputs. Make sure that we block off the player
	#	from transfering states with things like cancels until after the freeze
	#	frame has finished. Bcause of this, inputs should be cleared normally
	#	when the player doesn't touch anything for a bit, but also instead of
	#	clearing when the player inputs a move, clear it after that move does
	#	something, like a cancel into another move happens.
	#	EDIT: Now that we stop the characters from doing state speciffic code
	#	when in the hitstop this issue should no longer be a problem.
	

	
	# * We found out today that having a collision box with a width or height
	#	of 0 is still detected in collision detection, so because of that we
	#	can still keep it like that, but we'll need to add for the shape to be
	#	disabled in the actual animation player. Shouldn't be needed
	#	for anything but attack hitboxes but still important.
	
	
	# * Got them working right instanced! Now we can just put in what characters we
	#	want when instancing the scene, we should also make it so that we can speccify
	#	the size of the arena we will be fighting in, and also the background.
	#	To make things more universal, every player scene (for when we make Ash and Cole)
	#	should share the same names so the enemies can universally interact the same with any playable
	#	character.
	#	EDIT: We can also hack together a tiny room like an elevator by
	#	making the wallpadding bigger and having the camera extents be
	#	the size of the game window. Having some slaberknocker fights would
	#	be fun.

	# * figure out the priority of the Z-index, look at the games to see
	#	when one character should be drawed on top of another.
	# 	SOLVED:Whenever a punch if thrown out, set both of the characters 
	#	to that the one who just threw out of the punch is higher up.
	#
	
	
# ChangeLog:
	
	# * did some stress testing on strong hits to make sure that they don't
	#	push whoever is hitting them with them, they should stop when they hit
	#	the edge of the screen and the attacker is on the oposite end and that
	#	seems to work great on both sides. Also added a crouch for Josh
	#	and got the TRANSITIONING state working great.
	
	# * Did a lot of work, added the logic for when josh will get hit when
	#	we add enemy hitboxes, also have all the logic for stopping perfect.
	#	we also have shaking animations now.
	
	# * Got our hit that sends them in the air done, also figured out
	#	how to do the logic of the enemy hitting a wall while
	#	in the air so that only the initial force gets transferred to the player.
	
	# * Now when josh does a move that move is assigned to his currMove
	#	and we can use that for when a hit happens to an enemy to transfer
	#	the values of that move. We also established things for
	#	when the enemy is hit what should happen based on what kind of
	#	move it was and if they are grounded or not.
	
	# * Working with having the enemy go into an arch, added gravity to the
	#	enemy so it would work, and found a new problem to solve which might
	#	involve making a seperate state for free fall so nothing like
	#	the gravity gets reset when the player is out of hitstun and inputs
	#	won't do anything.
	
	# * Did some documentation work on the fighting Camera and created a 
	#	great camera for the overworld
	
	# * Now works on a wall! transfers knockback to the player. Next let's get
	#	the shaking consistent, use this algorithm below to confirm frame data
	#	so we can give that info to the player, and then let's make the logic
	#	for a move that launches the enemy in the air (we can use the same animations,
	#	just change the move type to launch and have logic for it
	#	in the hitstun state (think of the logic like a small jump backwards,
	#	you've done this before).
	#		We can test how many frames it takes for moves to come out and 
	#		get definitive amounts by having a function when the animation 
	#		starts that sets a condition to true and resets the counter to 
	#		zero and then add’s +1 for the frame is starts and every other 
	#		frame until the active frames starts, we then call another 
	#		function which prints out how many frames it took in total in 
	#		game. This will give us a definitive answer as to how many 
	#		frames something takes for startup, active, and recovery 
	#		animations and we can give this data to the player through 
	#		stats on the move.


	
	# * got the logic working for knockback, and made HitBoxes node so that
	#	we can put all the logic of intersecting hit and hurtboxes in one place
	
	# * Solved the problem with the collision only happening once a frame.
	#	(and I kept all the features too!) The only issue is that things aren't
	#	done until the next frame, which makes me think we probably need to 
	#	create something similar to what we did with pushchecking but for all
	#	the other logic that involves area2D collisions for attacks or grabs.
	#	this would be useful as we'd be able to know what both character we're doing
	#	because this logic will be executed after all of that, definetely do this.
	#	both to simplify and organize but also to make the game smoother and
	#	more consistent.
	
	# * made a dictionary for josh and found the next thing to solve,
	#	getting it so that a collision can only happen once a frame.
	
	# * Getting back into working on this, got the particle working as well
	#	as added functions to return the characters to neutral after an attack
	#	or stun finishes. I also made the enemy velocity dependent on it
	#	being in a nuetral state, and have the logic for how they react
	#	to a hit done in Josh's hitbox script, some of this stuff needs to be
	#	in the enemies hurtbox script. There's also in algorithm in there
	#	on a scene we can make for particles so that they delete themselves
	#	once the animation finishes.
	
	# * PLAYER AND ENEMY ARE NOT 100% SEPERATE FROM THE FIGHT SCENE, MEANING
	#	WE DON'T NEED TO MAKE SEPERATE SCENES FOR EVERY DIFFERENT MATCHUP
	#	AND INSTEAD WE CAN JUST USE ONE, WITH A FUNCTION THAT LOADS
	#	THE CHARACTERS, BACKGROUNDS, AND SIZE.
	
	# * Finished our pushboxes and camera, got Josh and the Enemy into their
	#	own scenes, got the flipping working, made the inputs enums
	
	# * Wonderful! this script is back to being used mainly for inputs.
	#	we got all of Josh's logic put into his own script, and we
	#	fixed up pushChecking by having the character on the wall reset
	#	both when moving towards them, but also when the velocity is == 0
	#	only thing left to do is do the thing with the priority involving
	#	the character position subtracted by the collision shape position
	#	After this, let's get the flipping working for both characters, and
	#	then start doing punches!
	
	# * Wow did we do a lot! We transfered our pushing to the bottom of
	#	the node tree below our two characters, meaning they can do
	#	whatever movement they want, and if that movement ends up with
	#	them colliding, things will happen depending.
	#	We also build some small bit of AI for our enemy so that they jump.
	#	We will use this next time to make our final changes to our pushbox,
	#	that being our heigherarchy of who is pushing who when on top of each other
	#	We've also started making the enemy character script with it's own states
	#	and inputs, and what those will do, this will be the foundation for which
	#	we make our characters in the game and their AI. Also added a raycast
	#	to the enemy with working gravity.
	
	# * We found out that it's not even important to reset just when we get
	#	to the top, and that we can do that with the bit of code that
	#	resets a character when they are too inside the other character
	#	because of this we don't even need to write and keep track of variables
	#	for the vertical extents of the pushboxes, and we now only need to do
	#	priority for who resets who, this will be done by seeing who is higher
	#	up than the other, and otherwise probably base it on who has the faster
	#	velocity. We'll keep the code commented out for now though just in case
	#	we ever need to put it back.
	
	# * with our new wallPadding variable that we use for the extents, we can
	#	now have different sized pushboxes, and as long as they are less than
	#	the wall extents in size, they will now work with no issues. We still
	#	need to figure out the vertical extents and get the priority working
	#	for pushing characters out of the way, but damn is it looking clean
	#	now when we play. There's a small thing where the hitboxes aren't
	#	perfectly on the sizes when both move in the same direction from oposite
	#	sizes of the screen, but it's so situation and there's no jitter or anything
	#	the player would notice that it's not worth worrying about. GREAT JOB!
	#	
	
	# * I've finally made represented the extents of the boxes with variables,
	#	so far it seems perfect, but we should test it a bit more while working on
	#	the camera. I need to do it vertically also for the reset when on top of the enemy.
	
	# * Finally back, and got some good work done, we have finally made the
	#	push boxes look and feel very natural by adding a condition to let
	#	characters pushing each other section of the function. Where we now have
	#	contitions for when characters are restrating, if the character catches up to
	#	them and pushes them, and they are faster, the slower character will
	#	be pushed by the normal velocity of the faster character. We now also
	#	know what is causing issues with the camera, which we will work on tomorrow.
	
	# * We got pushing working pretty damn good now! characters now push each other
	#	and I believe I now have the system so nobody ever has their boxes intersect
	#
	# * Well we finally found out how to get things working a bit better after
	#	all the stress, testing for collision at the end, pushing the bodies
	#	by both velocities, and when we're in the air, resetting the ground
	#	character when on top of them, we also got this all working with
	#	characters in a corner, the issue now is that flipping causes problems
	#	due to godot's engine, what we'll have to do now is both wait for godot
	#	3.1, but also flip things so that it's only the hit boxes, hurt boxes
	#	and sprites that we're scaling so we won't run into this weird issue.
	#	BE PROUD OF YOURSELF, YOU'VE DONE A GOOD JOB AND IT WORKS FOR THE MOST PART
	#	THE ISSUES IN THE EXECUTION ARE JUST FROM ISSUES IN THE ENGINE, COMMENT AND TAKE
	#	A BREAK ON THINGS FOR A BIT AND STUDY! EXERCISE TOMORROW AND SPEND TIME
	#	FOR YOURSELF!
	
	# * I made it so that the flips with both characters are independent, which
	#	will make for more realistic testing, but still haven't gotten much progress
	#	on fixing the collision boxes, I need to find a way to make it so that
	#	the boxes don't get stuck on each other, but also aren't jittery once
	#	we start to move things, if we can accomplish this we'll only
	#	need to worry about the two characters pushing each other right.
	
	# * out condition for the wall isn't even doing anything at all, we'll 
	#	which is a good thing since that means our code just works. Just need
	#	to find a solution for keep the boxes so they never intersect (even
	#	when up against a wall) and find a way to get the collision box to
	#	work with the bounds of the box (if we can't find this our we'll just
	#	use a variable and export it to change it in the animation player, probably
	#	find a way to have it work with an offset as well), also changed it back
	#	to the simple position between josh and enemy check for if it's flipped or not.
	#	(we want this only really happening when in a neutral state like idle or walking.
	#	right at the end of an attack also)
	#	Messed with the camera as well and played with only midpoint calculations
	#	but it has the issue of the camera jumping when chracters teleport, which I don't want
	#	probably keep it the same as it is now but maybe add some code to detect if
	#	somebody is in the area2D, and while it's detecting them move the camera left or right
	#	by a pixel or two every frame, or some other algorithm, maybe one that pushes the camera
	#	so other bodies never intersect with it. BASICALLY PERFECT THE CAMERA
	#	AFTER ALL THIS SO WE CAN MOVE ON TO HIT BOXES EFFECTING HURTBOXES!
	
	# * the collision is getting there! clamp is wonderful and has simplified things
	#	a lot! excited to keep working on and perfect the system.
	
	# * Got character flipping working, along with the gravity system now using
	#	a raycast system on it's own mask with the ground so that the player can't
	#	stand on the enemy, changed the collision shape to capsules to give a better
	#	result. WE NOW HAVE ENEMIES WE CAN JUMP OVER, AS WELL AS PUSH AWAY IF WE JUMP ON TOP
	#
	# * Changed josh's jump from 360 to 420 so he jumps a bit higher now.
	#
	# * fixed the camera state issue and now have it working almost perfectly!
	#
	# * Added enemyVeloicity as a variable, right now it's just for testing
	#	with the camera. Also animations are being ignored right now so we
	#	can get the camera perfect.
	#
	# * Added camera and got midpoint working with the camera, now I need 
	# to figure out the other algorithm for when they're closer.
	#
	# * Got diagonal jumps working great
	#
	# * Fixed the jumping so that now we only have to menipulate a value
	#	to decide how high josh jumps, which will be used for when he gets
	#	hit in the air as well. Feel free to tweak the gravity amount (at
	#	20 right now) if we want josh desending a bit slower
	#
	# * HOLY SHIT! We got all of the logic for flipping a character and
	#	all their boxes and everything just by scaling the Josh node to
	#	(-1, 1). Had to deal with a bug in the rotation in godot, but 
	#	it will probably be solved for 3.1.
	#
	# * Got Jumping working! Very exciting, we've added a new set of
	#	boxes for the floor and later the sides, and we have a new
	#	animation for josh, which we can put frames into later. We
	#	made some new variables to work with like joshWalkingSpeed, a 
	#	variable to easily control how josh moves side to side, we've
	#	also went from move_and_collide to move_and_slide. We also added
	#	a new state to the enum: JUMPING. Also tested walls with the enemy
	#	pushing me into it and so far they work great!
	#
	# * Got pushing working from atleast the normal way they face each
	#	other, need to get it working from the other side also. Split the
	#	logic for this up into both a script on Josh's pushbox as well as
	#	a general script for the enemy so they can move. also added
	#	a new subfolder for scripts called FightingCore, which has all of the
	#	scripts for this scene, very important for how the core of this fighting
	#	system will work
	#
	# * put both the bag and josh in the same scene for now, also got pushing
	#	working a bit (although we need to make it so josh's pushbox is what
	#	moves it, not his normal hitbox).
	#
	# * organized the boxes into hit boxes, hurt boxes, and have a normal
	#	box that will be used with out kinematic body to keep us bound with
	#	outer boxes. Also got a system that allows josh to always face his oponent,
	#	need to figure out how to make this work with the hitboxes
	#
	# * Changed the system to that we only have one timer for our inputs instead of
	#	making a new one for every input, this will help with performance, but also
	#	make it so that if we are moving right, the input won't be forgotten after
	#	half a second, meaning we won't have pauses in our movement so the program
	#	can place a new input in when it's empty.
	
# SMASH ATTACK: IF walking == false and right+punch is pressed
	
var playerInput = null
var previousInput = null	# Is held to prevent redundent inputs from the player holding a button
onready var inputTimer = get_node("InputClear")		# an array to hold our inputs' timers
var inputPool = []		# an array to hold our inputs

var playerInputs = []
var inputLag = null

var inLag = false

enum input {
	
	NONE,
	LEFT,
	RIGHT,
	UP,
	DOWN,
	UP_RIGHT,
	UP_LEFT,
	DOWN_RIGHT,
	DOWN_LEFT,
	LIGHT_AT,
	MEDIUM_AT,
	HARD_AT
	
}





# INPUTLAG: How long it takes before our last input in the pool is put into
#			our inputs used in game for animations and such
# INPUTCLEAR: How long it takes with no new inputs before the elements in 
#			playerInputs are cleared.



func _ready():
	

	pass
	#window_size = Vector2(1008, 672)

	#inputTimer = get_node("InputClear")
	
	

func _physics_process(delta):


	# TESTING CAMERA ZOOM FOR FUN
#	if (Input.is_action_pressed("Create")):
#		get_node("Camera2D").zoom.x -= 0.001
#		get_node("Camera2D").zoom.y -= 0.001
#	elif (Input.is_action_pressed("Action")):
#		get_node("Camera2D").zoom.x += 0.001
#		get_node("Camera2D").zoom.y += 0.001
	

	#------------------------------------------------
	# calculations for inputs start here
	


	playerInput = input.NONE	# Standing
	
	# check to see what the player is holding
	playerInput = inputGrabber()

	
	
	#stateMachineUpdate(playerInput)
	
	# We now do input slightly differently, not discarding redundant inputs until
	# our InputLag timer finishes
	
		
	# place the input into our pool
	inputPool.append(playerInput)
	
	if (playerInput != previousInput):

		inputTimer.wait_time = 0.1
		inputTimer.one_shot = true	# keeps the timer from resetting once it hits 0
		inputTimer.start()

		
		# start input lag
		if (!inLag):
			inLag = true
			get_node("InputLag").start()
		

	# For the next frame, for the if condition above
	previousInput = playerInput

	# Max size of our pool is 5
	if (inputPool.size() > 5):
		inputPool.pop_front()
			
		
	# when we have an inputs in our pool to do things with
	if (playerInputs.size() > 0):
				
		# once our timer has finished
		if (inputTimer.time_left <= 0):
			playerInputs.clear()		# do the same with the input pool
			#previousInput = null
			
			
		# keeps us from holding too many inputs
		if (playerInputs.size() > 10):
			playerInputs.pop_front()
			#playerInputs.clear()

		# THIS IS WHAT WAS MAKING THINGS GO CRAZY WITH THE CPUX!!!
		# for outputting out input pool to the console
#		var inputPoolExport = ""
#		for i in range(playerInputs.size()):
#			if (playerInputs[i] != ""):
#				inputPoolExport += playerInputs[i] + " "
#		print(inputPoolExport)
		


	
	# QCF + P!, get this working maybe so we can just get the index and compare that in the checks
	# and then if it passes change it to be the next one
	# also make this input a function
	if (playerInputs.find(input.DOWN, 0) != -1):
		var index = playerInputs.find(input.DOWN, 0)
		if (playerInputs.find(input.DOWN_RIGHT, index) != -1):
			index = playerInputs.find(input.DOWN_RIGHT, index)
			# added lenience
			if (playerInputs.find(input.RIGHT, index) != -1):
				index = playerInputs.find(input.RIGHT, index)

				if (playerInputs.find(input.LIGHT_AT, index) != -1):
					print("QCF+P!")
					#playerInputs.clear()
					
	if (playerInputs.find(input.RIGHT, 0) != -1):
		var index = playerInputs.find(input.RIGHT, 0)
		if (playerInputs.find(input.DOWN, index) != -1):
			index = playerInputs.find(input.DOWN, index)
			if (playerInputs.find(input.DOWN_RIGHT, index) != -1):
				index = playerInputs.find(input.DOWN_RIGHT, index)
				if (playerInputs.find(input.LIGHT_AT, index) != -1):
					print("DragonPunch")				
	
	if (playerInputs.find(input.DOWN, 0) != -1):
		var index = playerInputs.find(input.DOWN, 0)
		if (playerInputs.find(input.NONE, index) != -1):
			index = playerInputs.find(input.NONE, index)
			if (playerInputs.find(input.DOWN, index) != -1):
				index = playerInputs.find(input.DOWN, index)
				if (playerInputs.find(input.LIGHT_AT, index) != -1):
					print("hahaHAHA")
					
					




func inputGrabber():
	
	var inputOut #= "Standing"
	
	if (Input.is_action_pressed("Action")):

		inputOut = input.LIGHT_AT
			
	elif (Input.is_action_pressed("Soft")):

		inputOut = input.LIGHT_AT

	elif (Input.is_action_pressed("Medium")):

		inputOut = input.MEDIUM_AT

	elif (Input.is_action_pressed("Hard")):

		inputOut = input.HARD_AT
	
	elif (Input.is_action_pressed("Up")):
		if (Input.is_action_pressed("Right")):
			inputOut = input.UP_RIGHT
		elif (Input.is_action_pressed("Left")):
			inputOut = input.UP_LEFT
		else:
			inputOut = input.UP
	elif (Input.is_action_pressed("Right")):
		if (Input.is_action_pressed("Up")):
			inputOut = input.UP_RIGHT
		elif (Input.is_action_pressed("Down")):
			inputOut = input.DOWN_RIGHT
		else:
			inputOut = input.RIGHT
	elif (Input.is_action_pressed("Down")):
		if (Input.is_action_pressed("Right")):
			inputOut = input.DOWN_RIGHT
		elif (Input.is_action_pressed("Left")):
			inputOut = input.DOWN_LEFT
		else:
			inputOut = input.DOWN
	elif (Input.is_action_pressed("Left")):
		if (Input.is_action_pressed("Up")):
			inputOut = input.UP_LEFT
		elif (Input.is_action_pressed("Down")):
			inputOut = input.DOWN_LEFT
		else:
			inputOut = input.LEFT
			
	else:
		inputOut = input.NONE
		
	return inputOut
	



# You go here once the lag is all done, where it will take your last input and
# place it in the playerInputs variable have thing things done with
func _on_InputLag_timeout():

	get_node("InputLag").stop()
	inLag = false
	
	

	playerInputs.append(inputPool[inputPool.size()-1])

		# make a timer for the input
#		var timer = Timer.new()
#		timer.wait_time = 0.5
#		timer.one_shot = true	# keeps the timer from resetting once it hits 0
#		timer.start()
#		add_child(timer)
#		inputTimer.append(timer)	
	# clears all the inputs to start the next delay
	inputPool.clear()









