extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var health = 100
var stocks = 5
var redHealth = health


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	#OS.window_size = Vector2(1008, 672)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (Input.is_action_just_pressed("Action")):
		health -= 15
		
		# and stocks are > 0
		if (health <= 0):
			health += 100
			stocks -= 1
			redHealth += 100
			
		get_node("Sprite").region_rect = Rect2(0, 0, health, 5)
		
	if (redHealth != health):
		# if you want to be cool we can have it not go down until
		# the the hitstun has worn off on the oponent, meaning combos
		# will create a big red bar
		redHealth -= 1
		
		if (redHealth <= 0):
			redHealth += 100
			
		if (redHealth < health):
			redHealth = health
			
		get_node("Red").region_rect = Rect2(0, 0, clamp(redHealth, 0, 100), 5)

		
	
		

