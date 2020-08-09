extends CanvasLayer



enum tab { STATUS, ABILITIES, PHONE, JOURNAL, OPTIONS }
var currTab

enum menu { STATUS, ABILITIES, PHONE, JOURNAL, OPTIONS, TABS, START, EXIT }
var currMenu

var currAbility

const TAB_DISC = ["STATUS: Focus on yourself",
 "ABILITIES: Change up your game",
 "PHONE: Relax with some friends",
 "JOURNAL: How are you feeling?",
 "OPTIONS: Tweak your settings"]

# STATUS
const COL = 4
const ROW = 3
var selPosition = Vector2(0, 0)


func _ready():



	currTab = tab.STATUS


	
	currMenu = menu.START
	
	# everything is invisible until the animation finishes
	get_node("STATUS").visible = false
	
	# Also update this whenever we get a new move
	get_node("ABILITIES").updateAbilityList()
	currAbility = 0 # Starts at zero, saves the player's position
					# on the ability page





func _physics_process(delta):
	
	
	
	match currMenu:
		
		menu.START:
			if(Input.is_action_just_pressed("Start") && OverworldVariables.canWalk):
				
				#update all the variables here when we have them
				
				OverworldVariables.canWalk = false
				get_node("Animation").play("Open")
				get_node("TABS/" + str(currTab) + "/ani").play("Tab")
		
		menu.TABS:
			
			match currTab:
				tab.STATUS:
					if (Input.is_action_just_pressed("Down")):
						get_node("TABS/" + str(currTab) + "/ani").play_backwards("Tab")
						tabDown() # Abilities

						print(true)
						
				
					elif (Input.is_action_just_pressed("Up")):
						get_node("TABS/" + str(currTab) + "/ani").play_backwards("Tab")
						tabUp()
							
							
					elif(Input.is_action_just_pressed("Action")):
						get_node("STATUS/Consumables").play("spread")
						selPosition = Vector2(1, 0)
						get_node("STATUS/sel").visible = true
						currMenu = menu.STATUS
						
				tab.ABILITIES:
					if (Input.is_action_just_pressed("Down")):
						get_node("TABS/" + str(currTab) + "/ani").play_backwards("Tab")
						tabDown()

				
					elif (Input.is_action_just_pressed("Up")):
						get_node("TABS/" + str(currTab) + "/ani").play_backwards("Tab")
						tabUp()
							
							
					elif(Input.is_action_just_pressed("Action")):
						changeText(get_node("ABILITIES").get_children()[currAbility].discription)
						changeText(get_node("ABILITIES/Ability/").discription)
						currMenu = menu.ABILITIES
						#get this all done with the currAbility array

						get_node("ABILITIES").get_children()[currAbility].selected = true
						get_node("ABILITIES").get_children()[currAbility].get_node("Box/Bar").texture = get_node("ABILITIES").get_children()[currAbility].selectedSprite
						get_node("ABILITIES").get_children()[currAbility].get_node("Box/Shift").play("shift")

				tab.PHONE:
					if (Input.is_action_just_pressed("Down")):
						get_node("TABS/" + str(currTab) + "/ani").play_backwards("Tab")
						tabDown() # Abilities
						
					elif (Input.is_action_just_pressed("Up")):
						get_node("TABS/" + str(currTab) + "/ani").play_backwards("Tab")
						tabUp()
						
					elif(Input.is_action_just_pressed("Action")):
						pass
				tab.JOURNAL:
					if (Input.is_action_just_pressed("Down")):
						get_node("TABS/" + str(currTab) + "/ani").play_backwards("Tab")
						tabDown() # Abilities
						
					elif (Input.is_action_just_pressed("Up")):
						get_node("TABS/" + str(currTab) + "/ani").play_backwards("Tab")
						tabUp()
						
					elif(Input.is_action_just_pressed("Action")):
						pass
				tab.OPTIONS:
					if (Input.is_action_just_pressed("Down")):
						get_node("TABS/" + str(currTab) + "/ani").play_backwards("Tab")
						tabDown() # Abilities
						
					elif (Input.is_action_just_pressed("Up")):
						get_node("TABS/" + str(currTab) + "/ani").play_backwards("Tab")
						tabUp()
						
					elif(Input.is_action_just_pressed("Action")):
						pass
					
#			if (Input.is_action_just_pressed("Down")):
#				get_node("TABS/" + str(currTab) + "/ani").play_backwards("Tab")
#
#				currTab += 1
#				if (currTab > tab.size() - 1):
#					currTab = tab.STATUS
#				get_node("TABS/" + str(currTab) + "/ani").play("Tab")
#				changeText(TAB_DISC[currTab])
#
#			elif (Input.is_action_just_pressed("Up")):
#				get_node("TABS/" + str(currTab) + "/ani").play_backwards("Tab")
#
#				currTab -= 1
#				if (currTab < tab.STATUS):
#					currTab = tab.size() - 1
#				get_node("TABS/" + str(currTab) + "/ani").play("Tab")
#				changeText(TAB_DISC[currTab])
#
#			elif(Input.is_action_just_pressed("Action")):
#				currMenu = currTab
#
#				# the initial thing to do when entering
#				match currMenu:
#					menu.STATUS:
#						get_node("STATUS/Consumables").play("spread")
#						selPosition = Vector2(1, 0)
#						get_node("STATUS/sel").visible = true
#
#					menu.ABILITIES:
#						changeText(get_node("ABILITIES/Ability/").discrition)
#						currAbility = 0 # used for array
#					menu.PHONE:
#						pass
#					menu.JOURNAL:
#						pass
#					menu.OPTIONS:
#						pass
						
			if (Input.is_action_just_pressed("Start")):
				exit()
				
		menu.STATUS:
			if (get_node("STATUS/Consumables").is_playing()):
				get_node("STATUS/sel").position = get_node("STATUS/1").position
			
			if (Input.is_action_just_pressed("Down")):
				selPosition.y += 1
				if (selPosition.y >= COL):
					selPosition.y = 0
					get_node("STATUS/sel").position.y = (get_node("STATUS/" + str(selPosition.x)).position.y)
					print(true)
				else:
					get_node("STATUS/sel").position.y += 28
					
			
			elif (Input.is_action_just_pressed("Up")):
				selPosition.y -= 1
				if (selPosition.y < 0):
					selPosition.y = COL - 1
					get_node("STATUS/sel").position.y = (get_node("STATUS/" + str(selPosition.x)).position.y + ((COL - 1) * 28))
		
				else:
					get_node("STATUS/sel").position.y -= 28
			
					
			elif (Input.is_action_just_pressed("Left")):
				selPosition.x += 1
		
				if (selPosition.x >= ROW):
					selPosition.x = 0
					get_node("STATUS/sel").position = Vector2((get_node("STATUS/" + str(selPosition.x)).position.x), (get_node("STATUS/" + str(selPosition.x)).position.y + (28 * (selPosition.y))))
				else:
					get_node("STATUS/sel").position -= Vector2(36, -10)

				
				
			elif (Input.is_action_just_pressed("Right")):
				selPosition.x -= 1
		
				if (selPosition.x < 0):
					selPosition.x = ROW - 1
					get_node("STATUS/sel").position = Vector2((get_node("STATUS/" + str(selPosition.x)).position.x), (get_node("STATUS/" + str(selPosition.x)).position.y + (28 * (selPosition.y))))
				else:
					get_node("STATUS/sel").position += Vector2(36, -10)
					
			elif (Input.is_action_just_pressed("Create")):
				currMenu = menu.TABS
				get_node("STATUS/sel").visible = false
				get_node("STATUS/Consumables").play_backwards("spread")
				
			if (Input.is_action_just_pressed("Start")):
				exit()
				

			
			
		menu.ABILITIES:
			if (Input.is_action_just_pressed("Start")):
				exit()
			if (Input.is_action_just_pressed("Action")):
				get_node("ABILITIES").get_children()[currAbility].switch()

				
			if (Input.is_action_just_pressed("Create")):
				currMenu = menu.TABS
				get_node("ABILITIES/Ability").selected = false
				get_node("ABILITIES").get_children()[currAbility].get_node("Box/Bar").texture = get_node("ABILITIES").get_children()[currAbility].deselectedSprite
				get_node("ABILITIES").get_children()[currAbility].get_node("Box/Shift").play_backwards("shift")
				changeText(TAB_DISC[currTab])
				
			# allow wrap around and add ability
			elif (Input.is_action_just_pressed("Up")):
				get_node("ABILITIES").get_children()[currAbility].get_node("Box/Shift").play_backwards("shift")
				get_node("ABILITIES").get_children()[currAbility].get_node("Box/Bar").texture = get_node("ABILITIES").get_children()[currAbility].deselectedSprite
				
				currAbility -= 1
				if (currAbility < 0):
					currAbility = AbilityData.ability.size()-1
					
				changeText(get_node("ABILITIES").get_children()[currAbility].discription)	
				get_node("ABILITIES").get_children()[currAbility].get_node("Box/Shift").play("shift")
				get_node("ABILITIES").get_children()[currAbility].get_node("Box/Bar").texture = get_node("ABILITIES").get_children()[currAbility].selectedSprite
			
			elif (Input.is_action_just_pressed("Down")):
				get_node("ABILITIES").get_children()[currAbility].get_node("Box/Shift").play_backwards("shift")
				get_node("ABILITIES").get_children()[currAbility].get_node("Box/Bar").texture = get_node("ABILITIES").get_children()[currAbility].deselectedSprite
				
				currAbility += 1
				if (currAbility > AbilityData.ability.size()-1):
					currAbility = 0
				changeText(get_node("ABILITIES").get_children()[currAbility].discription)
				get_node("ABILITIES").get_children()[currAbility].get_node("Box/Shift").play("shift")
				get_node("ABILITIES").get_children()[currAbility].get_node("Box/Bar").texture = get_node("ABILITIES").get_children()[currAbility].selectedSprite	
		menu.PHONE:
			if (Input.is_action_just_pressed("Start")):
				exit()
			print("KEY ITEMS")
		menu.JOURNAL:
			if (Input.is_action_just_pressed("Start")):
				exit()
			print("JOURNAL")
		menu.OPTIONS:
			if (Input.is_action_just_pressed("Start")):
				exit()
			print("OPTIONS")
			
		menu.EXIT:
			pass

		

func changeText(text):
	get_node("Text/Sprite/Label").text = text
	get_node("Text/Sprite/Label").visible_characters = 0

	get_node("Text/Sprite/Label").timer.start()
	
func exit():
	
	# Basically does the same thing as exiting to tabs
	# mainly useful for exiting the menu when in a non-tab menu
	# cleans it all up, especially useful since we want the menu
	# to always be in memory
	match currMenu:

		menu.STATUS:
			get_node("STATUS/sel").visible = false
			get_node("STATUS/Consumables").play_backwards("spread")
			
		menu.ABILITIES:
			get_node("ABILITIES/Ability").selected = false
			get_node("ABILITIES").get_children()[currAbility].get_node("Box/Bar").texture = get_node("ABILITIES").get_children()[currAbility].deselectedSprite
			get_node("ABILITIES").get_children()[currAbility].get_node("Box/Shift").play_backwards("shift")

			
		
	get_node("TABS/" + str(currTab) + "/ani").play_backwards("Tab")
	get_node("Animation").play_backwards("Open")
	currMenu = menu.EXIT
	get_node(tab.keys()[currTab]).visible = false
	

		
	
# gets rid of redundant code
func tabDown():
	#disable previous UI
	get_node(tab.keys()[currTab]).visible = false
	currTab += 1 # Abilities

	# wrap around	
	if (currTab > tab.size() - 1):
		currTab = tab.STATUS
	# diplay new stuff
	get_node(tab.keys()[currTab]).visible = true
	get_node("TABS/" + str(currTab) + "/ani").play("Tab")
	changeText(TAB_DISC[currTab])
	
func tabUp():
	#diable previous UI
	get_node(tab.keys()[currTab]).visible = false
	currTab -= 1
	# wrap around
	if (currTab < tab.STATUS):
		currTab = tab.size() - 1
	# display new stuff
	get_node(tab.keys()[currTab]).visible = true
	get_node("TABS/" + str(currTab) + "/ani").play("Tab")
	changeText(TAB_DISC[currTab])
	
	

func _on_Animation_animation_finished(anim_name):
	# tab.keys()[currTab] gives us the name of our current enum
	print(menu.keys()[currMenu])
	match currMenu:
		
		# since we change from START to TABS right when start is pressed
		# TABS
		menu.START:
			currMenu = menu.TABS
			get_node(tab.keys()[currTab]).visible = true
			changeText(TAB_DISC[currTab])
	
		menu.EXIT:
			# Allows us to pause again
			currMenu = menu.START
			
			OverworldVariables.canWalk = true
			changeText("")
		

