extends CharacterBody2D

@export var move_speed: float = 150
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_game_over: bool = false

func _physics_process(delta: float) -> void:
	if not is_game_over:
		velocity = Input.get_vector("left", "right", "up", "down") * move_speed

		if velocity == Vector2.ZERO:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
			animated_sprite_2d.flip_h = velocity.x < 0

		move_and_slide()

func game_over():
	is_game_over = true
	animated_sprite_2d.play("game_over")
	await get_tree().create_timer(3).timeout
	get_tree().reload_current_scene()