extends Area2D

@onready var game_controller = $"../GameController"

func _physics_process(delta: float) -> void:
	if GameManager.game_state == GameManager.GameState.PLAYING:
		position += Vector2(game_controller.bullet_base_speed, 0) * delta
		if position.x > 470:
			queue_free()