extends Area2D

@onready var game_controller = $"../GameController"

@export var bullet_sprite: Sprite2D

@export var bullet_base_speed: float = 200
var bullet_direction: int = 1 # 1: right, -1: left

func _physics_process(delta: float) -> void:
	if GameManager.is_game_playing():
		bullet_move(delta)
		bullet_check_remove()

func bullet_move(delta: float):
	if bullet_direction == 1:
		position += Vector2(bullet_base_speed, 0) * delta
		bullet_sprite.flip_h = false
	else:
		position += Vector2(-bullet_base_speed, 0) * delta
		bullet_sprite.flip_h = true

func bullet_check_remove() -> void:
	if position.x > 240 or position.x < -240:
		bullet_remove()


func bullet_remove() -> void:
	game_controller.sence_bullet_count -= 1
	queue_free()