extends Control

@onready var messagespace = $Panel/VBoxContainer/chatbox/ScrollContainer/ItemList
@onready var lineedit_value = $Panel/VBoxContainer/chatinputbox/chat_input

@onready var chatbox = $Panel/VBoxContainer/chatbox
@onready var chatinputbox = $Panel/VBoxContainer/chatinputbox

@onready var scroll = $Panel/VBoxContainer/chatbox/ScrollContainer
@onready var scrollbar : VScrollBar = scroll.get_v_scroll_bar()

@onready var temperature_input = $Panel/VBoxContainer/HBoxContainer/secretkeybox2/SpinBox


var httprequest

var api_key

var role = """"""

var messages=[
	{"role": "system", "content": role}
]

func _ready():
	httprequest = $HTTPRequest

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#scroll.scroll_vertical=scrollbar.max_value


func _on_line_edit_text_submitted(new_text):
	var message = preload("res://message.tscn").instantiate()
	message.text="> "+new_text
	messagespace.add_child(message)
	lineedit_value.text=""
	GPT_send_prompt(new_text)
	

func GPT_send_prompt(prompt):
	messages.append({"role": "user", "content": prompt})
	var payload = {
		"model": "gpt-3.5-turbo",
		"messages": messages,
		"temperature" : temperature_input.value,
		"top_p":1.0,
		"n" : 1,
		"stream": false,
		"presence_penalty":0,
		"frequency_penalty":0,
	}
	
	var headers = [
 		"Content-Type: application/json",
		"Authorization: Bearer %s" % api_key
	]
	
	var payload_str = JSON.new().stringify(payload)
	

	httprequest.request("https://api.openai.com/v1/chat/completions",headers,HTTPClient.METHOD_POST,payload_str)

func _on_http_request_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	var response = null #json["choices"][-1]["message"]["content"]
	if json.has("error"):
		response=json["error"]["message"]
	if json.has("choices"):
		response=json["choices"][-1]["message"]["content"]
	
	if response != null:
		var message = preload("res://message.tscn").instantiate()
		message.text=" "+response
		messagespace.add_child(message)
		await get_tree().create_timer(1.0).timeout
		scroll.scroll_vertical=scrollbar.max_value

func _on_chat_input_text_submitted(new_text):
	scroll.scroll_vertical=scrollbar.max_value
	var message = preload("res://message.tscn").instantiate()
	message.text="> "+new_text
	messagespace.add_child(message)
	lineedit_value.text=""
	GPT_send_prompt(new_text)
	await get_tree().create_timer(1.0).timeout
	scroll.scroll_vertical=scrollbar.max_value

func _on_secretkey_input_text_changed(new_text):
	api_key=new_text
