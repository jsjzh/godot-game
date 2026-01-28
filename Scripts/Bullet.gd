extends Area2D

@export var bullet_speed: float = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not GameManager.instance.is_game_over:
		position += Vector2(bullet_speed, 0) * delta
		if position.x > 470:
			queue_free()