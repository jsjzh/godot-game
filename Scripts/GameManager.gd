extends Node

static var instance: GameManager = null

signal game_over
signal game_pused
signal game_playing

enum GameState {
	PLAYING,
	GAME_OVER,
	PUSED
}

var game_state: GameState = GameState.PLAYING

func _init():
	instance = self

func trigger_game_state(new_state: GameState):
	game_state = new_state
	if new_state == GameState.GAME_OVER:
		game_over.emit()
		await get_tree().create_timer(3).timeout
		get_tree().reload_current_scene()
	elif new_state == GameState.PUSED:
		game_pused.emit()
	elif new_state == GameState.PLAYING:
		game_playing.emit()
