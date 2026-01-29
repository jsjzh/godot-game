extends Area2D

@onready var game_controller = $"../GameController"

@export var slime_animated_sprite: AnimatedSprite2D
@export var slime_audio_dead: AudioStreamPlayer

var is_dead: bool = false

func _physics_process(delta: float) -> void:
	if GameManager.is_game_playing() and not is_dead:
		position += Vector2(-game_controller.slime_base_speed, 0) * delta
		if position.x < -250:
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('player') and not is_dead:
		GameManager.trigger_game_state(GameManager.GameState.GAME_OVER)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet") and not is_dead:
		is_dead = true
		area.queue_free()
		game_controller.bullet_count -= 1
		slime_animated_sprite.play("dead")
		slime_audio_dead.play()
		game_controller.trigger_add_score(1)
		await get_tree().create_timer(0.6).timeout
		queue_free()
