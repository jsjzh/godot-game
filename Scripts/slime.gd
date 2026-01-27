extends Area2D

@export var slimeSpeed: float = 50

func _physics_process(delta: float) -> void:
	position += Vector2(-slimeSpeed, 0) * delta


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		print("Slime hit the player!")
		body.game_over()
