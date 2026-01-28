extends Area2D

func _physics_process(delta: float) -> void:
	if not GameManager.instance.is_game_over:
		position += Vector2(GameManager.instance.game_state.bullet_base_speed, 0) * delta
		if position.x > 470:
			queue_free()