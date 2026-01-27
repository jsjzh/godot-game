extends Node

static var instance: GameManager = null

signal game_over

var is_game_over: bool = false

func _init():
	instance = self

func trigger_game_over():
	is_game_over = true
	game_over.emit()
	await get_tree().create_timer(1).timeout
	reset_game()

func reset_game():
	is_game_over = false
	get_tree().reload_current_scene()