extends Area2D

var pushChecking = false

func _ready():
	get_node("../../Enemy/pushBox").connect("area_entered", self, "_on_pushBox_area_entered")
	get_node("../../Enemy/pushBox").connect("area_exited", self, "_on_pushBox_area_exited")
	

func _on_pushBox_area_entered(area):
	if (area.get_name() == "pushBox"):
		self.pushChecking = true

#	pass


func _on_pushBox_area_exited(area):
	if (area.get_name() == "pushBox"):
		self.pushChecking = false

#	pass





