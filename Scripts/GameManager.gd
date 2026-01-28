extends Node

static var instance: GameManager = null

signal game_over
signal add_score(score: int)

var is_game_over: bool = false
var score: int = 0

func _init():
	instance = self

func trigger_game_over():
	is_game_over = true
	game_over.emit()
	await get_tree().create_timer(1).timeout
	reset_game()

func trigger_add_score(points: int):
	if is_game_over:
		return
	score += points
	add_score.emit(score)

func reset_game():
	is_game_over = false
	get_tree().reload_current_scene()
