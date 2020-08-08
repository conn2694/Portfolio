extends KinematicBody2D

var velocity = Vector2(0, 0)
var walkingSpeed = 180
var jumpHeight = 480
var flipped = false
var enemy = null
var camera = null
var gravity = Vector2(0, 0)

# all the different kinds of moves something can be (grab wouldn't use this logic)
enum MOVE_TYPE {
	AIR,
	LAUNCH,
	SOFT,
	NORMAL,
	HARD,
	TRIP
}

const MOVES = {
	LIGHT_PUNCH = {
		STUN = "light",	# a string to feed to the animation player on hit.
		KNOCK_BACK = 400,
		TYPE = MOVE_TYPE.LAUNCH
		
	} 
	
}

var currMove = null


enum state {
	TRANSITIONING,
	CROUCHED,
	CROUCHING,
	STANDING,
	PUNCHING
	CROUCH_PUNCHING
	JUMPING
	JUMPING_FORWARD
	JUMPING_BACKWARD
	HIT_STUN
}
var currState = state.STANDING
var transitionState = null

# this library will be where all of josh's moves and their properites are
# such as knockback, if it trips or not, if it hits them in the air, base damage
var move = {}

var input = null
var button = null
var rayCast = null
var aniMenipulation = Vector2(0, 0) # for when we want to move josh with the
									# animationPlayer
var wallPadding = 30
export var pushBoxW = 18


# freeze frame
var aniTime = 0
var stopped = false
var grounded = false

var interpolatePush = 0
var ani = null
#var items = preload("res://Scenes/General/Menus/Consumables/Main.tscn")
#var start = null	# Item instance

func _ready():
	rayCast = get_node("RayCast").is_colliding()
	button = get_node("../..").input
	enemy = get_node("../Enemy")
	camera = get_node("../../Camera2D")
	ani = get_node("AnimationPlayer")
	

	#get_node("JoshSprite").material.set_shader_param("in1", Color(0.231, 0.537, 0.772))
	#get_node("JoshSprite").material.set_shader_param("out1", Color(0.92549, 0.635294, 0.596078))
	
	

func _physics_process(delta):

	
	enemy = get_node("../Enemy")
	camera = get_node("../../Camera2D")
	rayCast = get_node("RayCast").is_colliding()
	velocity = Vector2(0, 0)
	

	
	input = get_node("../..").playerInputs
	

	if (!stopped):
	
		
		gravity.y += 20	# only happen when we're off the ground, as the move
	
		
		
		# NEW UPDATE: CHANGE OUR STATE MACHINE TO HAVE TWO ARGUMENTS, ONE FOR
		# OUR CURRENT INPUT, AND ONE FOR THE INPUTS IN OUR POOL, work on this more
		# to figure it out, it should be more clean than this.
	#	# Called every frame. Delta is time since last frame.
	#	# Update game logic here.
		if (input.size() > 0):
			stateMachineUpdate(input[input.size()-1])
		else:
			# This might be a hack, but if our inputs have been cleared, we just use the 
			# playerInput of this frame, this allows us to continue walking and so forth.
			# I can't imagine how this may cause problems as when playerInputs is reset,
			# it's almost immediately appended with the input (even if it's just ""), as
			# all this implies that we're still holding the same button we were before it
			# got cleared
			stateMachineUpdate(get_node("../..").playerInput)
			
		
		velocity += aniMenipulation + gravity
		self.move_and_slide(velocity)
		self.position.x = round(clamp(self.position.x, camera.position.x - (336/2) + wallPadding, camera.position.x + (336/2) - wallPadding))
		
	else:
		stop()
		
	gravity.x = 0
	
	#item menu test
	# Fix this, have it already instanced at the start of the match
	# Menu up should only bring the animation out and allow
	# for the inputs to matter, all of this can be done
	# in the menu scene itself, when josh uses an item
	# because the menu is open all the time in the back we
	# can just take the currItem and use it, no hassle on the josh
	# scene part like it is right now
	#if (Input.is_action_just_pressed("Menu Up")):
	#	start = items.instance()
	#	add_child(start)

	

func stateMachineUpdate(input):


	var characterSprite = get_node("Sprite")



	match currState:
		
		state.STANDING:
			
			# this if else checks and makes sure josh and the target always look at each other
			# we have this so it only works in the neutral states like idle or walking
			match flipped:
		
				true:
					#josh.scale = Vector2(-1, 1)


					
					# eventually change 18 into our extents
					if (self.position.x < enemy.position.x):
						flipped = false
						
						# do all our flips here so we don't need to do it every
						# frame
						get_node("JoshSprite").flip_h = false
						get_node("HurtBoxes").scale = Vector2(1, 1)
						get_node("HitBoxes").scale = Vector2(1, 1)
						
				false:
					#josh.scale = Vector2(1, 1)


					
					if (self.position.x > enemy.position.x):
						flipped = true
						get_node("JoshSprite").flip_h = true

						get_node("HurtBoxes").scale = Vector2(-1, 1)
						get_node("HitBoxes").scale = Vector2(-1, 1)

					
			gravity = Vector2(0, 120)
			
			# if we don't include UP_RIGHT, we won't get velocity for that
			# frame, which will make the pushing awkward when pushing against
			# each other.
			if (input == button.RIGHT || input == button.UP_RIGHT):
				velocity.x += walkingSpeed
				#get_node("Sprite").position.x += 1
			elif (input == button.LEFT || input == button.UP_LEFT):
				velocity.x -= walkingSpeed
				#get_node("Sprite").position.x -= 1
			
			if (input == button.DOWN):
				transitionState = state.CROUCHED
				currState = state.TRANSITIONING
				ani.play("Crouch")
			
			# jumps
			elif (input == button.UP):
				# the force josh jumps, increase to make him jump higher
				gravity = Vector2(0, -jumpHeight)
				currState = state.JUMPING
				get_node("AnimationPlayer").play("JoshJump")
			
			# make sure these two are reversed when we are flipped
			elif (input == button.UP_RIGHT):
				gravity = Vector2(0, -jumpHeight)
				currState = state.JUMPING_FORWARD
				get_node("AnimationPlayer").play("JoshJump")
				
			elif (input == button.UP_LEFT):
				gravity = Vector2(0, -jumpHeight)
				currState = state.JUMPING_BACKWARD
				get_node("AnimationPlayer").play("JoshJump")

				
			if (input == button.LIGHT_AT):
				get_node("AnimationPlayer").play("JoshPunch")
				currMove = self.MOVES.LIGHT_PUNCH
				currState = state.PUNCHING
			
		
			
		state.CROUCHED:
			
			if (input == button.LIGHT_AT):
				currState = state.CROUCH_PUNCHING
				characterSprite.texture = preload("res://Sprites/fighting/Josh/crouchy-punchy-guy.png")
			
			elif (input != button.DOWN):
				transitionState = state.STANDING
				currState = state.TRANSITIONING
				ani.play_backwards("Crouch")
				
		# What we'll use most of the time to get us from one main state
		# to the other
		state.TRANSITIONING:

			
			if (!ani.is_playing()):
				currState = transitionState
		# This let's us cancel the crouch if we let the button off of

				
		state.PUNCHING:
			# press left to go back to standing for now
#			if (input == button.LEFT):
			if (!ani.is_playing()):
				currState = state.STANDING

#				currState = state.STANDING
#				characterSprite.texture = preload("res://Sprites/fighting/Josh/fighty-guy.png")
			pass
		state.CROUCH_PUNCHING:
			
			if (input == button.LEFT):
				currState = state.CROUCHING
				characterSprite.texture = preload("res://Sprites/fighting/Josh/crouchy-guy.png")
				
		# if we are in this state, we have an animation that is going
		# against the normal gravity, but eventually goes to 0 and let's
		# the gravity do the rest (replacing this with a better system soon
		state.JUMPING:
			
			if (rayCast):
				# play the recovery animation, which will then go into this
				# state, but this works for now.
				currState = state.STANDING
				
		state.JUMPING_FORWARD:
			velocity.x += walkingSpeed
			if (rayCast):
				currState = state.STANDING
				
		state.JUMPING_BACKWARD:
			velocity.x -= walkingSpeed
			if (rayCast):
				currState = state.STANDING
				
				
		state.HIT_STUN:
			pass
				
func backToNeutral():
	# we want to add an if check to make sure the player doesn't go back
	# to a neautral state if they get hit out of their attack, however if
	# they get to the end of a punch animated and it isn't interupted part way
	# by an attack, this should be free to do, but it might be a good
	# insurance to make sure it's stable
	currState = state.STANDING

# The frame after we play any new animations we need, we stop the player
# on the first frame, and save the time that we were in.
func stop():
	aniTime = get_node("AnimationPlayer").current_animation_position
	get_node("AnimationPlayer").stop(false)
