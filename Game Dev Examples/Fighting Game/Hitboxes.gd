extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var player = null
var playerHitB = null
var playerHurtB = null
var enemy = null
var enemyHitB = null
var enemyHurtB = null

# save animation
var playerAni = ""
var enemyAni = ""


func _ready():

	enemy = get_node("../Players/Enemy")
	player = get_node("../Players/Player")
	playerHitB = get_node("../Players/Player/HitBoxes")
	playerHurtB = get_node("../Players/Player/HurtBoxes")
	enemyHitB = get_node("../Players/Enemy/HitBoxes")
	enemyHurtB = get_node("../Players/Enemy/HurtBoxes")

# This will most likely go in a new node just like Pushchecking.	
func _physics_process(delta):
	

	
	# For when the player hits
	if (playerHitB.hurtShapes.size() > 0):


		# loads a particle, eventually replace this sprite with a scene that will
		# have an animatedSprite node, this scene will play the animation and then
		# free it at the end by checking for if the animation is finished.
		# the name of the animation we choose can be based on an element in our
		# future dictionary for the data on all of our moves
		var loadParticle = Sprite.new()
		loadParticle.texture = load("res://Sprites/fighting/Items/fightingGameMovementImage.png")
		loadParticle.set_as_toplevel(true)	# this makes the position independent of the parents
											# we don't want it moving with josh.
											
		# EVENTUALLY: Take the average of all the hitshpes, than the average of all
		# the hurt shapes, than take the midpoint between them for this.
		loadParticle.global_position = get_node("../Players/Player/HitBoxes/" + str(playerHitB.hitShapes[0])).global_position
		# above both players, we want it being high on the layer heirarchy.
		loadParticle.z_index = 5
		add_child(loadParticle)
		
		
		# even though we have to wait until the next frame to push the enemy back in his hit_stun state
		# it's okay because we need to do a pause to show the impact of the hit anyways.
		enemy.interpolatePush = 0
		# we can't put them in a frozen state on the same frame we put them
		# into the hitstun and play the stun animation, so do that here, and then
		# next frame when they are in the stun animation, that's when we stop everything.
		get_node("../Players/Enemy").currState = get_node("../Players/Enemy").state.HIT_STUN
		get_node("../Players/Enemy/AnimationPlayer").play("Bag")

		
		# the player is kept the in the same hit state, just paused.
		player.stop()
		
		
		# save the animations for when the freeze is done
		enemyAni = get_node("../Players/Enemy/AnimationPlayer").current_animation
		playerAni = get_node("../Players/Player/AnimationPlayer").current_animation
		# start the timer
		get_node("FreezeFrame").start()
		
		# get rid of these so we don't run this code again next frame.
		playerHitB.hurtShapes.clear()
		playerHitB.hitShapes.clear()
		
		# If the player is in the air, or it's one of the moves that puts the character in
		# the air, we will use this logic while they are in stun
		if (!enemy.rayCast || player.currMove.TYPE == player.MOVE_TYPE.LAUNCH || player.currMove.TYPE == player.MOVE_TYPE.TRIP):
			enemy.grounded = false
		else:
			enemy.grounded = true
			
		# Now that we know if we are grounded or not, we disable the raycast
		# while the hitstop happens so that when it's over the hit won't still
		# think it's suppose to be on the floor.
		# WE DON'T NEED TO DISABLE THE RAYCAST ANYMORE BY CHECKING FOR STOPPED
		# INSTEAD OF WHEN THE CLOCK RUNS OUT.
		get_node("../Players/Enemy/RayCast").enabled = false
		player.stopped = true
		enemy.stopped = true
		
		# shake the hit enemy. Do the stopping in the their own process
		# so that this frame can put them in the stun animation before it's
		# then stopped
		get_node("../Players/Enemy/Shake").play("hitShake")
		#enemy.stop()
		
		
	# enemy hit player, this is an if and not elif because both can in fact
	# happen if both characters hit each other on the same frame.
	if (enemyHitB.hurtShapes.size() > 0):
		
		#############################################
		# Do the particles later once we finish the player version above
		#############################################
		print(true)
		player.interpolatePush = 0
		
		get_node("../Players/Player").currState = get_node("../Players/Player").state.HIT_STUN
		#############################################
		# Play Hit animation here
		#############################################
		
		enemy.stop()
		
		# currently gives errors with josh because technically no animation plays
		# when josh walks into the bag's hitbox. This animation error will probably
		# be fixed when we have animations playing all the time for both characters.
		enemyAni = get_node("../Players/Enemy/AnimationPlayer").current_animation
		playerAni = get_node("../Players/Player/AnimationPlayer").current_animation
		# start the timer
		get_node("FreezeFrame").start()
		

		
		enemyHitB.hurtShapes.clear()
		enemyHitB.hitShapes.clear()
		
		if (!player.rayCast || enemy.currMove.TYPE == enemy.MOVE_TYPE.LAUNCH || enemy.currMove.TYPE == enemy.MOVE_TYPE.TRIP):
			player.grounded = false
		else:
			player.grounded = true
		

		get_node("../Players/Player/RayCast").enabled = false
		player.stopped = true
		enemy.stopped = true
		
		get_node("../Players/Player/Shake").play("hitShake")


# freeze frame is over.
func _on_FreezeFrame_timeout():
	# resume enemy animation
	get_node("../Players/Enemy/AnimationPlayer").play(enemyAni)
	get_node("../Players/Enemy/AnimationPlayer").seek(enemy.aniTime)
	# Stops the shaking if they were hit and resets to frame 0 where
	# the displacement was 0
	get_node("../Players/Enemy/Shake").stop(true)

	
	# resume player animation.
	get_node("../Players/Player/AnimationPlayer").play(playerAni)
	get_node("../Players/Player/AnimationPlayer").seek(player.aniTime)
	get_node("../Players/Player/Shake").stop(true)
	
	# we want to do it here so that the height won't change until after the freeze stops
	# 500 here is arbitrary to make the arch more obvious.
	enemy.gravity = Vector2(0, -player.MOVES.LIGHT_PUNCH.KNOCK_BACK - 200)

	get_node("../Players/Player/RayCast").enabled = true

	player.stopped = false
	enemy.stopped = false

