extends Node2D

signal smack_talked(smack_talk)
signal move_made(move_description)
signal game_over(game_over_message)

var move_counter: int = 0
var turn_counter: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$smack_talk_requests.request_completed.connect(_on_smack_talk_request_completed)
	$move_description_requests.request_completed.connect(_on_move_description_request_completed)
	$game_over_message_requests.request_completed.connect(_on_game_over_message_request_completed)

func _on_player_selected_cell(cell_name):
	turn_counter += 1
	move_counter = (turn_counter * 2) - 1
	var coords: Vector2i = Common.get_cell_coordinates_by_name(cell_name)
	var cell_common_name: String = Common.get_cell_common_name(coords.x, coords.y)
	var request_data = {
		"turn_number": turn_counter,
		"cell_common_name": cell_common_name
	}
	
	var json: String = JSON.stringify(request_data)
	$smack_talk_requests.request("https://sixam.azure-api.net/ttt/v1/describe-player-move", ["content-type: application/json"], HTTPClient.METHOD_POST, json)

func _on_opponent_selected_cell(cell_name):
	move_counter = (turn_counter * 2)
	var coords: Vector2i = Common.get_cell_coordinates_by_name(cell_name)
	var cell_common_name: String = Common.get_cell_common_name(coords.x, coords.y)
	var request_data = {
		"cell_common_name": cell_common_name
	}
	
	var json: String = JSON.stringify(request_data)
	$move_description_requests.request("https://sixam.azure-api.net/ttt/v1/describe-opponent-move", ["content-type: application/json"], HTTPClient.METHOD_POST, json)

func _on_player_won():
	do_game_over("player")

func _on_opponent_won():
	do_game_over("opponent")

func _on_tie():
	do_game_over("none")

func do_game_over(winner):
	var request_data = {
		"winner": winner
	}
	
	var json: String = JSON.stringify(request_data)
	$game_over_message_requests.request("https://sixam.azure-api.net/ttt/v1/describe-game-over", ["content-type: application/json"], HTTPClient.METHOD_POST, json)

func _on_smack_talk_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	var message: String = json.choices[0].message.content
	smack_talked.emit(message)

func _on_move_description_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	var message: String = json.choices[0].message.content
	move_made.emit(message) 

func _on_game_over_message_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	var message: String = json.choices[0].message.content
	game_over.emit(message) 
