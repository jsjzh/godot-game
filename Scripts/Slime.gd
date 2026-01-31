extends Area2D

@onready var game_controller = $"../GameController"

@export var slime_animated_sprite: AnimatedSprite2D
@export var slime_audio_dead: AudioStreamPlayer
@export var coin_scene: PackedScene

@export var slime_base_speed: float = 50
var is_dead: bool = false

func _physics_process(delta: float) -> void:
	if GameManager.is_game_playing() and not is_dead:
		position += Vector2(-slime_base_speed, 0) * delta
		if position.x < -250:
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('player') and not is_dead:
		body.handle_attack()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet") and not is_dead:
		is_dead = true
		area.queue_free()
		game_controller.sence_bullet_count -= 1
		slime_audio_dead.play()
		game_controller.trigger_add_score(1)
		slime_animated_sprite.play("dead")
		await slime_animated_sprite.animation_finished
		queue_free()

		# if randi() % 100 < 50: # 50% 概率掉落金币
		var coin_node = coin_scene.instantiate()
		coin_node.position = position
		get_tree().current_scene.add_child(coin_node)
		game_controller.trigger_not_picked_coin(1)