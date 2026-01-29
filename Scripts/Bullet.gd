extends Area2D

@onready var game_controller = $"../GameController"

@export var bullet_sprite: Sprite2D

var bullet_direction: int = 1

func _physics_process(delta: float) -> void:
	if GameManager.game_state == GameManager.GameState.PLAYING:
		if bullet_direction == 1:
			position += Vector2(game_controller.bullet_base_speed, 0) * delta
			bullet_sprite.flip_h = false
		else:
			position += Vector2(-game_controller.bullet_base_speed, 0) * delta
			bullet_sprite.flip_h = true
		
		if position.x > 240 or position.x < -240:
			queue_free()