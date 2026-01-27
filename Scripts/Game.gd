extends Node2D

var is_game_over: bool = false

func game_over():
	is_game_over = true
	for child in get_children():
		if child.has_method("game_over"):
			child.game_over()