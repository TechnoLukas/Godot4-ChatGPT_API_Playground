extends Control

var text = ""
@onready var textfield = $TextEdit

func _ready():
	textfield.text=text
	custom_minimum_size=Vector2(0,textfield.size.y)
	
func _process(delta):
	custom_minimum_size=Vector2(0,textfield.size.y)
	

