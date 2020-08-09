extends Label

# TODO:

	# * NARRATOR: Get it so we can get files in with *filename* + Narrator.json
	#	This shouldn't be that hard, we can find a substring function that let's
	#	us use everything and then delete the last 4 characters and replace it with
	# 	Narrator.json
	
	# * NARRATOR: Test that the narrator can do a divert to a second 
	#	bit of dialogue with no issues (this should already work)
	
	# * NARRATOR: See if we can get a way to get the narrator text centered
	
	# * NARRATOR: It's clunky right now as we need to press a button to
	#	start the narrator, a button to close him, and a button to advance.
	#	It should be treated as one long thing, one press should get all the
	#	dialogue and then the narrator, and the next press should remove the
	#	narrator AND advance to the next dialogue. If we make the dialogue more
	#	paced out so you read it as it happens and there's more timing, than
	#	it should be one fluid thing, maybe a small timer before the narrator comes
	#	on if we want extra tension. but otherwise it'd be best to make the
	#	narrator come on after a button press to the dialogue it's responding too.
	#	
	# * NEW THING: Since I imagine we'll want text being more timing based.
	#	let's add a way to have the dialogue make small pauses through a timer
	#	who's length we can specify in an array in the json, along with a 
	#	parallel array for what character indexs we want the pauses happening on
	
	# * have a default amount of pause for punctuation if there is no speciffied
	#	characters we want to pause on, if we do have speccific characters with
	#	speccific times, we'll override that and instead use the custom thing.
	#	This means we don't need to waste time putting the same thing in the dialogue
	#	anytime we have a comma, but it also allows us to get more speciffic if we want to.
	
	# * it might be nice to have folders for all the different character portraits
	#	and we choose the folder based off the name json variable, meaning instead
	#	of having to do open files like "josh_happy" we can have the json name variable
	#	open the josh folder, and set the "happy.png" image in the josh folder as the 
	#	portrait to save us time, and it will help us keep things organized.
	
	# * To have pauses in the text, the logic for it is right under the _draw()
	#	function, we could have a variable that is set to 0 when we divert
	#	(we could honestly just reset it whenever all the characters are drawn
	#	on screen, so in the area with the (visibleCharacters >= allCharacters0
	#	bit. and then check from the json araay with the element of the
	#	variable we establish above, whenever we do this, we set the wait_time
	#	to our parallel array that has the times that we want to pause.
	#	when this happens we increase our variable by 1, to took for the next area
	#	(if it doesn't go away from the array, we could use a clamp from 0 to
	#	the size of the array -1). Not sure how to deal with when a character
	#	we want to pause on is skipped by skipBy, maybe check for if it's over
	#	and if so reset the visible characters to the one we were looking for
	#	and then go from there, but give it some more thought because it's late
	#	right now.
	
	
	
	# * make a special version of the text box for illustration cutscenes
	#	that allows us to multiple portaits on the screen, and is more geared
	#	towards animating cutscenes. We have play animations, and instead of
	#	waiting for the box to be closed, we can have a json variable that get's checked
	#	for in a divert, if this new text being diverted to has the variable, we
	#	will play the next animation. This will make it easy to program it in
	#	since I'll just be calling a function that tests for the variable.
	#	because of this we will be instancing the textbubbles in the illustration
	#	cutscene scene so we can use it's variables.
	
	#	for the cutscenes we'll have a special variable that is set to false
	#	every frame at the beginning, and then is true only for one frame
	#	when we are diverting, this bool will be used to alert our animation script
	#	that it's time to move to the next animation. This could also maybe be a
	#	number that goes up, which we will use to speciffy what animation to play.
	#	because of this, the animations in this will almost all be one shots.
	#	Also this cutscene dialog shouldn't have names probably, and should have
	#	the illuminated character be the one talking, while the other characters
	#	have some transparency to them, or dark tint to put them out of focus.
	#
	#	We'll make the cutscene in the middle of a bigger cutscene in the top down
	#	view. it will be instanced on top of it, probably called in the animation
	#	player. And this will take over while the top down waits every frame
	#	for it to be closed so it can resume down there.
	
	# 	We also want it to be able to have quick moments of not talking, like mark taking
	#	the wine. We want to start the animation during dialog, the waiter will come and stop
	#	next to mark, on the next animation it will pick up with mark taking the drink, but we
	#	don't want dialog for this section, so we can use our "interput" to simulate a pause
	#	with a box full of spaces (since they also are programmed to not make noise). This means
	#	josh can pick up the wine, and we can space it so he has just enough time to take
	#	the wine and hold it before the interupt then continues the dialogue. We can use
	#	the characters as time, just set the "skipby" to 1, have it at the default fast speed
	#	and just draw more spaces if we need more, since it doesn't matter if spaces
	#	go outside the box. 
	#
	#	Also we'll probably need to store these as indevidual scenes, but that's alright.
	#
	# * What if we talk to a shop keeper and we have options like >shop >talk >leave
	#	it'd be good to have dialogue options on the right side along with the left
	#	(player) side.
	#	NOTE: Or just have the shop guy show up on the left side since they
	#	are special characters anyways, it's not like Josh needs to have a conversation
	#	with them, he's just buying some stuff.
	
	# * add an little thing at the bottom right of the screen once all the
	#	text is displayed that prompts the user to press Z
	
	# * have other sound effects, one maybe for when dialogue boxes are done opening
	#	also one for when we move our curser up and down on our choices
	
	# * if you have time and feel like it maybe you can give putting in
	#	shocked questions where the curser moves on it's own and you have to
	#	time a button press, and after a couple of times it chooses one at random
	#	for you
	
	

# Change Log:
	
	# * Fixed the branching path selector so that it's now in a nice box, and
	#	has different style for if we have two or three options. we can use the
	#	constant QUESTION_BOX_POSITION to change the coordinate of the box, but
	#	it's in a really nice position right now I think.
	
	# * Added function exitAni(), which is a block of reusable code that plays an
	#	exit animation to make the transition from exiting to entering animations.
	#	It's pretty clean and pasts the textTest, but give it a bit more testing
	#	if you need to. We didn't do it with interupt because we want interupt to be
	#	be a more shocking thing. But get feedback, make a build of textTest
	#	for both Steph and Kago.
	
	# * Got it so that it only opens and closes when it first opens and closes,
	#	otherwise it just swaps the character and name if nessisary.
	#	Test this a bit more, we just implimented it and we want it fool proof.
	#	Test different combinations of having things with and without names,
	#	different names and faces, all sorts of stuff like that.
	
	# * realised there's no reason to speed up when there's no speed element,
	#	because the default is already the max speed. I also made the default
	#	values constants that are easy to change when we need to.
	# * NEW: Added skipBy to make text even speedier if we need, and also had it
	#	so we'll reset it to the last possible visible text if it goes over since
	#	we can now count by two's and three's and might go over it.
	# * got the "sound" variable working in json, now just say what sound
	#	you want to play as text scrolls, and it will do it
	# * restructured the _process for things like interuptions, much less
	#	cluttered with the if statements now
	# * initialized choicesDone to true so that it's not checking for arrow
	#	directions while there's no arrow on screen. Just a reminder to always
	#	attempt ALL of your possible inputs when testing to make sure nothing
	#	sneaky is happening.
	# * I now have smooth transitions with the names so they don't abruptly change to
	#	the next character before they leave the textbox. This was done with the
	#	animation player and the changeName function being called in the character
	#	entering animations
	# * character can now interupt themselves, and have started changing the name
	# * added shocked and just character slide in animations, added variables
	#	to the json like name and sameChar that are used to determine certain
	#	animations. Also fixed a placing of where the time is reset when you leave
	#	a frame. Used the json variables to have it so if the same character
	#	is talking on the next divert you can have it so the whole textbox doesn't need
	#	to leave, just your character sprite getting replaced
	# * Can now have two or more question boxes in a single dialogue scene
	# * FIXED ERROR ABOVE
	# * Added new font from Steph and implimented a variable textSpace in
	#	the drawing section that decides the spacing of text
	# * Implimented the amount of pi minipulation 
	# * Added the "interupt" feature to the text, allowing for characters to 
	#	interupt others while text is scrolling, also made a shortcut for accesing
	#	the animation node
	
# Json variables:
	#	divert: 	changes to the specified dialogue
	#	continue: 	will keep the text around and use to divert to add that text with its properties
	#	isEnd:		end of your dialogue, when this is closed, the whole object will free itself
	#	interupt:	this will end the dialogue right away without the player
	#				pressing anything, good for if josh is interupted by another character
	#	speed: 		speed of text
	#	amp: 		the waviness of the text
	#	wave: 		the wave modulator, the speed of radius
	#	pi:			the period of the sinwave
	#	face:		sprite portait to be on top of the text
	#	name:		name of character, used to determine name tag and
	#				if we need to play the animation of the new name tag coming in or not
	#	sameChar:	if this is in there we'll keep the textbox there and just
	#				go to the next bit of dialogue without playing the leaving
	#				animations
	#	open:		which direction the dialogue with open and close
	#	shock:		if the character should come in shocked
	#	option:		for linkpaths, the text used to represent the option
	#	linkPath:	where that option diverts too
	#	color:		3 element array holding the RGB values for the text
	#	initial:	where the dialogue will begin
	#	skipBy:		how many characters get drawn on screen after the timer stops
	#				This stops the 60fps from bottlenecking how fast the text can show up
	#	special:	bool that decides if we have the text centered for something with
	#				effects or for events like Josh getting something.

# Functions:
	# newText:		call before initializing it, this takes two arguments, the json
	#				file, and the part of the file you want to call text from
	# endPremature:	allows for the textbox to be prematurely freed for some
	#				situational parts of cutscenes.


var font = preload("res://Sprites/General/Fonts/Aero.tres")
var dynamicFont = DynamicFont.new()


var waveModulator = 0	# the speed of the sine wave
var visibleText = 0		# the amount of visible characters at a time,
						# goes up whenever the timer resets
var allCharacters = 0	# gets all the characters of a string
var textSpeedUp = false
var pageText = {}		# Holds our json info
						
var currDialogue
var currChoices = []
var linkPath = false
var optionChoice = 0
var arrow = null
var questionBox = null
# change this to change the position of all the elements in the box
const QUESTION_BOX_POSITION = Vector2(35, 15)
var numOfNewLines = 0	# To figure out where to set the y-axis of our arrow
var storeNewLine = 0

# just in case we need the narrator scene we preload it
var narratorData = preload("res://Scenes/General/Text Box/Narrator.tscn")


# THIS WILL HOLD THE TEXT VALUES WHEN WE HAVE A "CONTINUE" VARIABLE IN OUR JSON,
# WE WILL FIRST STORE THE STRING (ALONG WITH THAT STRINGS SIZE AND IT'S PROPERTIES)
# EVERYTIME THERE IS A CONTINUE, WE COUNT HOW MANY BLOCKS OF TEXT WE ARE HOLDING
# THEN IN THE FOR LOOP, WE'LL HAVE AN EMPTY STRING VARIABLE AND ASSIGN IT TO THESE
# if (
var textHolding = []
var textHoldingCount = 0
						
	
var textBoxAniDone = false
var prematureEnd = false
var globalDrawText = ""		# used for our audio so that blank spaces don't have a sound to them

var textAni = null
var dialogueSet = ""		# takes the dialogue branch we put in newText and stores it so we can specify it all over
var fileSet = ""			# Takes the file name, mainly used for if we want to instance a narrator

var choicesDone = true		# hack vairable to make sure that once we choose an option that
							# we don't do the lines of code again, and lets us keep
							# linkPath for evaluation for once the animation finishes
var piAmount = 1			# set to 1 so that we don't ever get devision by 0
var nameBoxNode = null 

# if we want to start with a narration, we just 
# make the narration object.
var narrationActive = false
var globalTextInstance = null 	# for narration, lets us use weakref to check
								# if we can move on to the next thing.


## DEFAULT VALUES
const DEF_SPEED = 0.01
const DEF_WAVE_SPEED = 0.1
const DEF_PI = 8
const DEF_AMP = 0
const DEF_COLOR = Color(1, 1, 1)
const DEF_FACE = null
const DEF_NAME = null
const DEF_SKIP_BY = 1

var sameName = false
var sameFace = false

# decides wether to stop the player from walking, or if there are other
# settings like wanting the player to walk while interacting with it or
# something more speccific for cutscenes.
var textSetting = null





func _ready():

	textAni = get_node("../../CanvasLayer2/BottomBar/AnimationPlayer")
	nameBoxNode = get_node("../../CanvasLayer2/NameBox/Name")
	
	# decides if we should have text in the center or space it for two lines.

	if (currDialogue[1].has("special")):
		self.rect_position = Vector2(15, 213)
	else:
		self.rect_position = Vector2(15, 205)
	#OS.set_window_size(Vector2(1008, 672))
	
	dynamicFont.size = 16			# Size of our font	
	dynamicFont.font_data = font	# The font we established at the top
	
	#if (currDialogue == null):
	#	newText("res://test.json", "testingThisOut")
	

	# put the timers being set here so that text won't show up until AFTER
	# the animation is done playing
	if (currDialogue[1].has("name")):
		nameBoxNode.text = currDialogue[1].name if currDialogue[1].has("name") else " "
		if (currDialogue[1].has("shock")):
			textAni.play("shockComingInFrameRight")
		else:
			textAni.play("comingInFrameRight")
	else:
		textAni.play("comingInFrame")
			
#	if (currDialogue[1].has("open")):
#		nameBoxNode.text = currDialogue[1].name if currDialogue[1].has("name") else " "
#		if (currDialogue[1].has("shock")):
#			if (currDialogue[1].open == "left"):
#				textAni.play("shockComingInFrameLeft")
#			elif (currDialogue[1].open == "right"):
#				textAni.play("shockComingInFrameRight")	
#		else:
#			if (currDialogue[1].open == "left"):
#				textAni.play("comingInFrameLeft")
#			elif (currDialogue[1].open == "right"):
#				textAni.play("comingInFrameRight")
#
#
#	else:
#		textAni.play("comingInFrame")
#
	

	

func _process(delta):
	


	update()
	


	var waveSpeed = currDialogue[1].wave if currDialogue[1].has("wave") else DEF_WAVE_SPEED
	waveModulator += waveSpeed * (delta + 1)	# it needs to be added to every frame so that it doesn't reset to the beginning
	while (waveModulator > PI*2):
		waveModulator = 0
	
	# initial pi is 8, giving it  a smooth wavyness, make it 0 for dancing letters
	piAmount = currDialogue[1].pi if currDialogue[1].has("pi") else DEF_PI
		
	#print(waveSpeed)
	

		
	# tests every frame for the Z button, if all the characters are visible
	# our next block of text will be assigned in the other script, and
	# the visible text will go back down to 0 so it can start all over
	# if it hasn't, it will reveal all the characters
	
	if (visibleText >= allCharacters):
		
		if (Input.is_action_just_pressed("Action") && !linkPath && !currDialogue[1].has("continue") && !currDialogue[1].has("interupt")):
			
			# this means we have branching options
			if (currDialogue.size() > 2):

				linkPath = true
				choicesDone = false
				optionChoice = 0
				# we start at 2 to skip the first bit of dialogue and it's properties
				# and instead use it to count our choices
				for i in range(2, currDialogue.size(), 1):
					currChoices.append(currDialogue[i].option)
					# the + 2 is for the two \t's for our options
					allCharacters += (currDialogue[i].option.length() + 2)
					
				# for the one \n
				allCharacters += 1
				# doing this lets us just see the options right away
				visibleText = allCharacters
				get_node("textScroller").stop()
				
				storeNewLine = numOfNewLines
				arrow = Sprite.new()
				arrow.texture = load("res://Sprites/General/Dialogue/Text Boxes/arrow.png")
				arrow.offset = Vector2(200, -83)	# centers it in the way we want
			
				# load, position and resize the textbox.
				questionBox = Sprite.new()
				questionBox.texture = load("res://Sprites/General/Dialogue/Text Boxes/textBoxBlackBox.png")
				questionBox.z_index = -1 # so that the text can show through

				# changes the scale and position of the box and the positon of the
				# arrow based on if there are two or three options.
				if (currChoices.size() == 3):
					questionBox.scale = Vector2(0.25, 0.80)
					questionBox.position = Vector2(240, -58) + QUESTION_BOX_POSITION
					arrow.position = Vector2(5, (storeNewLine * 16 + 12)) + QUESTION_BOX_POSITION
				elif (currChoices.size() == 2):
					questionBox.scale = Vector2(0.25, 0.50)
					questionBox.position = Vector2(240, -58) + QUESTION_BOX_POSITION + Vector2(0, 10)
					arrow.position = Vector2(5, (storeNewLine * 16 + 19)) + QUESTION_BOX_POSITION + Vector2(0, 10)

				#print(currChoices.size()) # use this to get smaller boxes for less answers

				
				# 10 for the padding on the screen so it fits next to our answers
				# storeNewLine to make sure it always is relative to the size
				# of the dialogue above
				# 16 for the character height
				# 12 for the patting on top 
#				if (currChoices.size() == 3):
#					arrow.position = Vector2(5, (storeNewLine * 16 + 12)) + QUESTION_BOX_POSITION
#				elif (currChoices.size() == 2):
#					arrow.position = Vector2(5, (storeNewLine * 16 + 19)) + QUESTION_BOX_POSITION

				add_child(arrow)
				add_child(questionBox)
				
			# A normal divert
			else:
				
				# Triggers a narration dialogue to show up
				if (currDialogue[1].has("narration")):
					
					# the if is to make sure we only make one instance
					if (!narrationActive):
						var narratorFile = fileSet + "Narrator"
						var textInstance = narratorData.instance()
						# our text script is what stops us from walking, add anything besides 0 as another perameter
						# and we can walk while interacting
						textInstance.get_node("CanvasLayer/Label").newText("res://testNarrator.json", dialogueSet)
						add_child(textInstance)
						globalTextInstance = textInstance
						
					narrationActive = true
					
					#if (!weakref(globalTextInstance).get_ref()):					
					if (globalTextInstance.get_node("CanvasLayer/Label").visibleText >=  globalTextInstance.get_node("CanvasLayer/Label").allCharacters):
						# this should allow the program to move on
						# to the next thing of dialogue 
						narrationActive = false


				if (!narrationActive):
					# The json version of going up a page, we divert to the next section of the json file
					if (currDialogue[1].has("divert")):
						
						# since we're clearing the screen, there's no reason to hold onto
						# any of the info from previous screen
						textHolding.clear()
						textHoldingCount = 0
	
						# Do this before so the wait_time can be reset before the clock is started again
						visibleText = 0 
	
		
						# exits the same way we opened from
	
						# if our next dialogue is the same character
						# if (currDialogue[1].has("sameChar")):
							
						exitAni()
	
	
					# If it's the end of the dialogue box, we free the whole scene,
					# later on we will first have an animation play here with our box
					# so that it falls down and our character moves out of the window
					# and then freeing it. Also clears our json info
					elif (currDialogue[1].has("isEnd")): 
						visibleText = 0
						pageText.clear()
						
						if (currDialogue[1].has("name")):
							textAni.play("leavingFrameRight")
						else:
							textAni.play("leavingFrame")
							


						
		# choosing our options
		elif (!choicesDone):
			if (Input.is_action_just_pressed("Action")):
				OverworldVariables.optionChoice = optionChoice + 1
				choicesDone = true
				currChoices.clear()		# get rid of our choices to make room for more if we have them
				arrow.queue_free()		# get rid of the arrow sprite
				questionBox.queue_free()
				textHolding.clear()		# clears it sense we are moving to the next thing of text
				textHoldingCount = 0
				visibleText = 0
			
				exitAni()
					

						
			elif (Input.is_action_just_pressed("Down")):
				optionChoice += 1
				arrow.position.y += 12
				
				# wrap around when we try accessing an option higher than what we have
				if (optionChoice > currChoices.size() - 1):
					# original position
					if (currChoices.size() == 3):
						arrow.position.y = (storeNewLine * 16 + 12) + QUESTION_BOX_POSITION.y
					elif (currChoices.size() == 2):
						arrow.position.y = (storeNewLine * 16 + 19) + QUESTION_BOX_POSITION.y + 10

					optionChoice = 0
				
			elif (Input.is_action_just_pressed("Up")):
				optionChoice -= 1
				arrow.position.y -= 12
				
				# wraps around to the bottom
				if (optionChoice < 0):
					
					if (currChoices.size() == 3):
						arrow.position.y = (storeNewLine * 16 + 12) + (12 * (currChoices.size() -1)) + QUESTION_BOX_POSITION.y
					elif (currChoices.size() == 2):
						arrow.position.y = (storeNewLine * 16 + 19) + (12 * (currChoices.size() -1)) + QUESTION_BOX_POSITION.y + 10
					#arrow.position.y = (storeNewLine * 16 + 12) + (12 * (currChoices.size() -1)) + QUESTION_BOX_POSITION.y
					optionChoice = currChoices.size() - 1
					


		# for when we continue a string a text on the same dialogue tree
		elif (currDialogue[1].has("continue")):
	
			# If our text is going to continue, we are going to store all the previous info about our previous
			# dialogue in textHolding so all it's formatting can be used in the draw for loop
			# FACE is just used to compare it to the new one to see if we need to change it for the dialogue
			textHolding.append({
							dialogue = currDialogue[0],
							amp = currDialogue[1].amp if currDialogue[1].has("amp") else DEF_AMP,
							color = Color(currDialogue[1].color[0], 
										currDialogue[1].color[1], 
										currDialogue[1].color[2])
										if currDialogue[1].has("color") else DEF_COLOR,
							face = currDialogue[1].face if currDialogue[1].has("face") else DEF_FACE,
							charName = currDialogue[1].name if currDialogue[1].has("name") else DEF_NAME
			})
			
			textHoldingCount += 1
			
			# Instead of having the page go up by 1, we divert to the next area of the json
			currDialogue = pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"]
			# change portrait
			if (currDialogue[1].has("face")):
				# if it is the same face there's no reason in swapping out anything
				if (currDialogue[1].face != textHolding[textHoldingCount - 1].face):
				
					# different character (probably won't be used with continue but might as well have it)
					if (currDialogue[1].name != textHolding[textHoldingCount - 1].charName):
	
						textAni.play("characterSlideRight")
							
					# same character
					else:

						textAni.play("justCharacterSlideRight")
						
			# sets the wait_time variable before starting it
			# if we have a speed variable in this sections json we use that, otherwise we use a default of 0.1
			get_node("textScroller").wait_time = currDialogue[1].speed if currDialogue[1].has("speed") else DEF_SPEED
			get_node("textScroller").start()
			
		# one text box is replaced with another one with no input from the player
		# usually used to show a character interupting another
		elif (currDialogue[1].has("interupt")):

			# we have to do this since we don't call the animation until after it's already been switched
			var sameInterupt = false 	#character interupting themselves, doesn't play any animations on name box
	
			if (currDialogue[1].has("name") && pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"][1].has("name")):
				if (currDialogue[1].name == pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"][1].name):
					sameInterupt = true

					
			currDialogue = pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"]
			get_node("textScroller").wait_time = currDialogue[1].speed if currDialogue[1].has("speed") else DEF_SPEED
			visibleText = 0
			# open up the dialogue
			if (sameInterupt):
				
					if (currDialogue[1].has("shock")):
						textAni.play("shockJustCharacterSlideRight")
					else:
						textAni.play("justCharacterSlideRight")

					
			else:
	
					if (currDialogue[1].has("shock")):
						textAni.play("shockCharacterSlideRight")
					else:
						textAni.play("characterSlideRight")
							
							


			
			
	
	elif (visibleText < allCharacters):						
		if (Input.is_action_pressed("Action")):
			textSpeedUp = true 
		else:
			textSpeedUp = false
			

		
		



func _draw():

	# THIS IS WHERE OUR STUFF TO CHANGE WHERE THE PAUSED WOULD HAPPEN, have
	# it based on numbers for specified ones, have it based on punctuation
	# characters when nothing is speciffied. We'll need the variable
	# that holds the current dialogue text and put the visibleText-1 in for
	# array index.
	if (visibleText == 8):
		#get_node("textScroller").wait_time = 1
		pass
	else:
		get_node("textScroller").wait_time = currDialogue[1].speed if currDialogue[1].has("speed") else DEF_SPEED	# The speed that our text shows up on screen

		# for if Z is being held
		if (textSpeedUp && currDialogue[1].has("speed")):
			get_node("textScroller").wait_time = currDialogue[1].speed * 0.33 

	# gets all of our characters, every frame we first reset to 0, and then add
	# all of our previous text if it's continued, and then add to it our current
	# dialogue
	# NOTE: this can possibly be done above whenever we divert so we don't have to do
	#		it every frame
	allCharacters = 0
	if (textHoldingCount > 0):
		for i in range(textHoldingCount):
			allCharacters += textHolding[i].dialogue.length() 	
	allCharacters += currDialogue[0].length()
	
	
	var textBreak = 0
	var backToBeginning = 0	# used along with textBreak to give a new line
	# we declare and initialize these variables that will be menipulated in the for loop
	var drawAmp = 0.0
	var drawColor = Color(1, 1, 1)	
	# gets all of the text, first from the previous text if it's continued,
	# and then from our current dialogue
	var drawText = ""
	var choicePosition = Vector2(0,0)
	var questionNumber = Vector2(0, 0)
	
	# we do this now so we don't need to do this check for every single i
	# in the for loop, determines where on the screen the text should show up
	# based on how many choices there are on the screen.
	if (currChoices.size() == 3):
		questionNumber = Vector2(200, -80) + QUESTION_BOX_POSITION
	elif (currChoices.size() == 2):
		questionNumber = Vector2(200, -63) + QUESTION_BOX_POSITION


	
	if (textHoldingCount > 0):
		for i in range(textHoldingCount):
			drawText += textHolding[i].dialogue
	drawText += currDialogue[0]
	
	# used so that our colors don't effect the colors of the choices
	var beforeChoices = drawText.length()
	if (linkPath):
		# our first new line after our questions
		drawText += '\n'
		# tab for space, our choice, and then another newline
		for i in range(currChoices.size()):
			drawText += '\t' + currChoices[i] + '\n'
	globalDrawText = drawText

	var textSpace = 0

	numOfNewLines = 0
	for i in range(visibleText):
			
				
				
		# backToBeginning is basically i, only thing making it different 
		# is that it resets to 0 when the new line happens
		backToBeginning += 1


		# our current dialogue's formatting of the text, if we aren't continueing
		# or our previous continues are the same we'll just be using this
		drawAmp = currDialogue[1].amp if currDialogue[1].has("amp") else DEF_AMP
		drawColor = Color(currDialogue[1].color[0],
					currDialogue[1].color[1], 
					currDialogue[1].color[2]) if currDialogue[1].has("color") else DEF_COLOR
						

		if (textHoldingCount >= 1):
			if (i < textHolding[0].dialogue.length() && i >= 0):

				drawAmp = textHolding[0].amp
				drawColor = textHolding[0].color
		if (textHoldingCount >= 2):
			if (i < textHolding[1].dialogue.length() + textHolding[0].dialogue.length() && i >= textHolding[0].dialogue.length()):

				drawAmp = textHolding[1].amp
				drawColor = textHolding[1].color				
		if (textHoldingCount >= 3):		
			if (i < textHolding[2].dialogue.length() + textHolding[1].dialogue.length() + textHolding[0].dialogue.length() && i >= textHolding[1].dialogue.length() + textHolding[0].dialogue.length()):

				drawAmp = textHolding[2].amp
				drawColor = textHolding[2].color
		
		# For the choices, we use a white color and different coordinates so they
		# fit in the box
		if (i > beforeChoices):
			drawAmp = 0
			drawColor = Color(1, 1, 1)
			choicePosition = questionNumber	#position based on amount of choices
				
				
		
			
		# If certain characters are being drawn that are thinner, we 
		# subtrack a given amount in pixels from the location on the x-axis
		# the next characters will be
		if (i > 0):
			# i, l, and ' are very short, so we subtrack 4 pixels from following letters
			if (drawText[i-1] == 'i' || drawText[i-1] == 'l' || drawText[i-1] == '\'' || drawText[i-1] == 'í' || drawText[i-1] == '\"' || drawText[i-1] == '!' || drawText[i-1] == '.' || drawText[i-1] == ',' || drawText[i-1] == ';'):
				textSpace += 4
			# w and m are very big, so we add 1 pixel to the following letters
			elif (drawText[i-1] == 'w' || drawText[i-1] == 'm' || drawText[i-1] == 'M' || drawText[i-1] == 'W' || drawText[i-1] == 'O'):
				textSpace -= 2
				
			elif (drawText[i-1] == 'r' || drawText[i-1] == "j" || drawText[i-1] == ' '):
				textSpace += 1	
			
		# Since new line doesn't happen automatically, gotta do it ourselves
		if (drawText[i] == '\n'):
			numOfNewLines += 1 
			textBreak += 12
			backToBeginning = 0
			textSpace = 0	# since it's a new line we can reset our text spacing

			
		
		# Just PI makes the text dance
		draw_char(dynamicFont, 
			Vector2(backToBeginning * (dynamicFont.size * 0.375) - textSpace + choicePosition.x,		# the font size keeps the spacing consistent for if you change the font size, back to beginning makes it so that when a break happens it goes back to the first x value
			drawAmp * sin(i * PI/piAmount + waveModulator) + textBreak + choicePosition.y), # classic sin wave to do the waves, textBreak brings it down once \n happens
			drawText[i],	# Character drawn
			"a",	# Not sure what this does, but "a" seems to work just fine
			drawColor)		# The color of the character



	

func newText(textFile, textPath, textSettings = 0):
	fileSet = textFile
	dialogueSet = textPath
	# opens our json file for reading
	var file = File.new()
	file.open(textFile, File.READ)
	

	pageText = parse_json(file.get_as_text())
	
	# since we just parsed the json into memory, there's no reason to keep it open
	file.close()
	
	# the textpath is where we want our dialogue starting, the ["data"] and ["content"] 
	# just need to be there to get us to where we need, allowing us to just use
	# currDialogue[0] for the dialogue and currDialogue[1] for all it's properties
	currDialogue = pageText["data"][textPath][pageText["data"][textPath]["initial"]]["content"]

	# makes it more global so we can make the player walk again on "isEnd"
	textSetting = textSettings
	if (textSetting == 0):

		OverworldVariables.canWalk = false
		


func _on_Timer_timeout():
	visibleText += currDialogue[1].skipBy if currDialogue[1].has("skipBy") else DEF_SKIP_BY
	

		
	
	# Eventually get this to just stop the timer all together
	if (visibleText >= allCharacters):
		#print(true)
		visibleText = allCharacters
		get_node("textScroller").stop()
	
	# if there is no space
	if (globalDrawText[visibleText-1] != " " && ((visibleText) % 6 == 0)):
		

		# this successfully changes our sound for the text, this might be worth
		# calling when the currdialogue changes for optimization, but for now it works
		# fine
		var audioSource = null
		if (currDialogue[1].has("sound")):
			audioSource = load("res://Sound/SFX/Text Box/" + currDialogue[1].sound + ".wav")
		
		get_node("AudioStreamPlayer").stream = audioSource
		if (!get_node("AudioStreamPlayer").playing):	
			get_node("AudioStreamPlayer").play(0.0)
	

	


func endPremature():
	get_node("textScroller").stop()
	visibleText = 0
	prematureEnd = true
	if (currDialogue[1].open == "left"):
		textAni.play("leavingFrameLeft")
	elif (currDialogue[1].open == "right"):
		textAni.play("leavingFrameRight")
	else:
		textAni.play("leavingFrame")
	

func loadPortrait():
	if (currDialogue[1].has("face")):
		var portaitPath = "res://Sprites/General/Dialogue/Portraits/"
		portaitPath += currDialogue[1].face + ".png"
		
		get_node("../../CanvasLayer2/Character").texture = load(portaitPath)
	
	else:
		get_node("../../CanvasLayer2/Character").texture = null
		
# this is for when characters slide in from interupts or continues, doesn't
# change the name until the namebox is hidden in the section of animation
func changeName():
	nameBoxNode.text = currDialogue[1].name if currDialogue[1].has("name") else " "	

func comingIntoFrame():
   

	# starts timer
	get_node("textScroller").start()

	
func leavingFrame():
	

	
	if(currDialogue[1].has("isEnd") || prematureEnd):
		
		if (textSetting == 0):
			OverworldVariables.canWalk = true
		
		get_node("../..").queue_free()


	
	elif (currDialogue[1].has("divert") || linkPath):
		# wait to start the timer until the comingIntoFrame happens
		# For if we are moving to a new thing of dialogue
		if (currDialogue[1].has("divert") && !currDialogue.has("continue") && !linkPath):

			currDialogue = pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"]
			get_node("textScroller").wait_time = currDialogue[1].speed if currDialogue[1].has("speed") else DEF_SPEED
			# decides if we should have text in the center or space it for two lines.
			if (currDialogue[1].has("special")):
				self.rect_position = Vector2(15, 213)
			else:
				self.rect_position = Vector2(15, 205)
		
		# for after choosing your choice in a linkpath
		elif (linkPath):
			# before it was only showing optionChoice = 0 because it would put 
			# linkpath as false before the choices went out of frame, putting it here fixes it
			linkPath = false
			currDialogue = pageText["data"][dialogueSet][currDialogue[optionChoice + 2]["linkPath"]]["content"]
		
		# set new speed to the new dialogue, along with the name and making sure there's no visible text
		get_node("textScroller").wait_time = currDialogue[1].speed if currDialogue[1].has("speed") else DEF_SPEED
		nameBoxNode.text = currDialogue[1].name if currDialogue[1].has("name") else " "
		visibleText = 0		# This might be redundent, since the update already makes the visibleText = 0 when we advance the dialogue
		

		# After changing the dialogue, let's open our new dialogue here
		# USE THIS FOR THE SHOCKED REACTION ANIMATION and the animations
		# for new dialogue from the same character
		if (sameName):
			if (sameFace):
				comingIntoFrame()
			else:
				if (currDialogue[1].has("shock")):
					textAni.play("shockJustCharacterSlideRight")
				else:
					textAni.play("justCharacterSlideRight")
				
			
		else:
		
			if (currDialogue[1].has("shock")):
					textAni.play("shockCharacterSlideRight")
			else:
				if (currDialogue[1].has("name")):
					textAni.play("characterSlideRight")
	
				else:
					comingIntoFrame()
					
	sameName = false
	sameFace = false
	
	
func exitAni():
	# if we our current dialogue and the one we are diverting to both have
	# name, then we compare the name to figure out if it is the same one or not
	if (currDialogue[1].has("name") && pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"][1].has("name")):

		if (currDialogue[1].name == pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"][1].name):
			# do all the stuff we normally do in our leavingFrame function
			sameName = true

			# if we use the same face, no need to play any animations.
			if (currDialogue[1].face == pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"][1].face):
				textAni.play("JustDelay")
				sameFace = true

			else:
				textAni.play("CharLeaving")
			
		# both have a name but not the same character
		else:
			# so put them both back
			textAni.play("CharAndBoxLeaving")
	# Either of them don't have a name.
	else:
		# we don't want to be putting name back if we don't even have a name
		# on screen, so if we do have a name on our next one, let's get rid 
		# of the ones on there now.
		if (!pageText["data"][dialogueSet][currDialogue[1]["divert"]]["content"][1].has("name")):
			textAni.play("CharAndBoxLeaving")
		# the only way this should ever be triggered is if both the current box
		# and next box don't have names.
		else:
			textAni.play("JustDelay")

