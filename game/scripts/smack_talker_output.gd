extends Label

func _on_smack_talked(smack_talk):
	text = smack_talk

func _on_move_made(move_description):
	text += "\n" + move_description

func _on_game_over(game_over_message):
	text = game_over_message
