extends Area2D

@export var slimeSpeed: float = 50

func _physics_process(delta: float) -> void:
	if not GameManager.instance.is_game_over:
		position += Vector2(-slimeSpeed, 0) * delta

func _on_body_entered(body: Node2D) -> void:
	print("Slime collided with: ", body.name)
	if body is CharacterBody2D and body.name == "Player":
		GameManager.instance.trigger_game_over()
	elif body is Area2D and body.name == "Bullet":
		queue_free()
