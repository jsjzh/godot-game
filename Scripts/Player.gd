extends CharacterBody2D

@export var move_speed: float = 80
@export var animated_sprite_2d: AnimatedSprite2D
@export var bullet_scene: PackedScene

func _ready():
	GameManager.instance.game_over.connect(handle_game_over)

func _physics_process(delta: float) -> void:
	if not GameManager.instance.is_game_over:
		velocity = Input.get_vector("left", "right", "up", "down") * move_speed * 100 * delta

		if velocity == Vector2.ZERO:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
			animated_sprite_2d.flip_h = velocity.x < 0

		move_and_slide()

func handle_game_over():
	animated_sprite_2d.play("game_over")

func _on_fire() -> void:
	if velocity != Vector2.ZERO or GameManager.instance.is_game_over:
		return
	else:
			var bullet = bullet_scene.instantiate()
			bullet.position = position + Vector2(6, 6)
			get_tree().current_scene.add_child(bullet)
