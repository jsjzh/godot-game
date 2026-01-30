extends CharacterBody2D

@onready var game_controller = $"../GameController"

@export var player_animated_sprite: AnimatedSprite2D
@export var bullet_scene: PackedScene
@export var player_audio_fire: AudioStreamPlayer
@export var player_audio_run: AudioStreamPlayer

enum PlayerMoveType {IDLE, RUN, ROLL}

@export var player_base_speed: float = 80
@export var player_bullet_max_count: int = 3
var player_move_type = PlayerMoveType.IDLE
var player_direction: Vector2 = Vector2.ZERO
# 1: right, -1: left
var player_last_direction = 1

func _ready():
	GameManager.game_overed.connect(handle_game_over)

func _process(_delta):
	if GameManager.is_game_playing() and player_move_type == PlayerMoveType.RUN:
		if not player_audio_run.playing:
			player_audio_run.play()
	else:
		player_audio_run.stop()

func _physics_process(delta: float) -> void:
	if GameManager.is_game_playing():
		var speed = player_base_speed * 100 * delta
		velocity = Input.get_vector("left", "right", "up", "down") * speed

		if velocity == Vector2.ZERO:
			player_animated_sprite.play("idle")
		else:
			# if Input.is_action_just_pressed("roll"):
			# 	player_move_type = PlayerMoveType.ROLL
			# 	player_animated_sprite.play("roll")
			# 	await player_animated_sprite.animation_finished
			# 	player_move_type = PlayerMoveType.IDLE
			# 	pass
			# else:
			# 	pass
			if Input.is_action_pressed("right"):
				player_direction.x += 1
			if Input.is_action_pressed("left"):
				player_direction.x -= 1

			if player_direction.length() > 0:
				player_direction = player_direction.normalized()

			player_last_direction = sign(player_direction.x) if player_direction.x != 0 else player_last_direction

			player_animated_sprite.flip_h = player_last_direction < 0
			player_animated_sprite.play("run")
			# await player_animated_sprite.animation_finished

		move_and_slide()
		handle_fire()

func handle_fire():
	if Input.is_action_just_pressed("fire"):
		if game_controller.sence_bullet_count < player_bullet_max_count:
			var new_bullet = bullet_scene.instantiate()
			new_bullet.position = position + Vector2(6, 6) if player_last_direction > 0 else position + Vector2(-6, 6)
			new_bullet.bullet_direction = player_last_direction
			get_tree().current_scene.add_child(new_bullet)
			game_controller.sence_bullet_count += 1
			player_audio_fire.play()

func handle_game_over():
	player_animated_sprite.play("game_over")
