extends Node

signal player_selected_cell(cell_name)
signal opponent_selected_cell(cell_name)
signal player_won
signal opponent_won
signal tie

var locked: bool = false
var opponent_last_cell_selected: String

var game_board: Array[Array]

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(3):
		game_board.append([])
		for j in range(3):
			game_board[i].append("-")
	pass # Replace with function body.

func _on_cell_clicked(cell_name):
	if (locked):
		return
	locked = true
	
	var cell: Button = get_node("%" + cell_name)
	cell.disabled = true
	cell.text = "X"
	var coords: Vector2i = Common.get_cell_coordinates_by_name(cell_name)
	game_board[coords.x][coords.y] = "X"
	if is_player_winner("X"):
		player_won.emit()
	elif get_empty_count() == 0:
		tie.emit()
	else:
		player_selected_cell.emit(cell_name)

func _on_smack_talked(smack_talk):
	if get_empty_count() == 0:
		return
	await get_tree().create_timer(rng.randf_range(0.4, 1.7)).timeout
	var cell_coords = select_empty_cell()
	var cell_name = Common.get_cell_name_by_coordinates(cell_coords)
	opponent_last_cell_selected = cell_name
	game_board[cell_coords.x][cell_coords.y] = "O"
	if is_player_winner("O"):
		opponent_won.emit()
	else:
		opponent_selected_cell.emit(cell_name)

func _on_move_made(move_description):
	var cell: Button = get_node("%" + opponent_last_cell_selected)
	cell.disabled = true
	cell.text = "O"
	locked = false

func _on_smack_talker_game_over(game_over_message):
	var cell: Button = get_node("%" + opponent_last_cell_selected)
	cell.disabled = true
	cell.text = "O"

func select_empty_cell():
	var empties: int = get_empty_count()
	if empties <= 0:
		return
	var index: int = rng.randi_range(0, empties - 1)
	for x in 3:
		for y in 3:
			if game_board[x][y] != "-":
				continue
			else:
				if index > 0:
					index -= 1
				else:
					return Vector2i(x, y)

func get_empty_count():
	var empty_count: int = 0
	for i in game_board:
		for j in i:
			if j == "-":
				empty_count += 1
	return empty_count

func is_player_winner(player: String):
	if game_board[0][0] == player and game_board[0][1] == player and game_board[0][2] == player:
		return true
	if game_board[1][0] == player and game_board[1][1] == player and game_board[1][2] == player:
		return true
	if game_board[2][0] == player and game_board[2][1] == player and game_board[2][2] == player:
		return true
	if game_board[0][0] == player and game_board[1][0] == player and game_board[2][0] == player:
		return true
	if game_board[0][1] == player and game_board[1][1] == player and game_board[2][1] == player:
		return true
	if game_board[0][2] == player and game_board[1][2] == player and game_board[2][2] == player:
		return true
	if game_board[0][0] == player and game_board[1][1] == player and game_board[2][2] == player:
		return true
	if game_board[0][2] == player and game_board[1][1] == player and game_board[2][0] == player:
		return true
	return false


