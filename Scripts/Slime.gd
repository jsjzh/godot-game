extends Area2D

@export var slimeSpeed: float = 50
@export var animated_sprite_2d: AnimatedSprite2D

var is_dead: bool = false


func _physics_process(delta: float) -> void:
	if not is_dead and not GameManager.instance.is_game_over:
		position += Vector2(-slimeSpeed, 0) * delta
		if position.x < -250:
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	if not is_dead and body is CharacterBody2D and body.name == "Player":
		GameManager.instance.trigger_game_over()

func _on_area_entered(area: Area2D) -> void:
	if not is_dead and area.is_in_group("bullet"):
		GameManager.instance.trigger_add_score(1)
		is_dead = true
		area.queue_free()
		animated_sprite_2d.play("dead")
		await get_tree().create_timer(0.6).timeout
		queue_free()
