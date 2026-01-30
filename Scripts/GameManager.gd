extends Node

signal game_overed
signal game_pused
signal game_played

enum GameState {
	PLAYING,
	GAME_OVER,
	PUSED
}

enum PhysicsLayer {
	WALL = 1,
	PLAYER = 2,
	PLAYER_BUTTLE = 3,
	ENEMY = 4,
	COIN = 5,
}

var game_state: GameState = GameState.PLAYING

func trigger_game_state(new_state: GameState):
	game_state = new_state
	if new_state == GameState.GAME_OVER:
		game_overed.emit()
	elif new_state == GameState.PUSED:
		game_pused.emit()
	elif new_state == GameState.PLAYING:
		game_played.emit()


func is_game_playing() -> bool:
	return game_state == GameState.PLAYING