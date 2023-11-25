extends Control

var text = ""
@onready var label = $Label 

func _ready():
	label.text=text
	custom_minimum_size=Vector2(0,label.size.y)
	
func _process(delta):
	custom_minimum_size=Vector2(0,label.size.y)
	

