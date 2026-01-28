extends CharacterBody2D

@onready var game_controller = $"../GameController"

@export var animated_sprite_2d: AnimatedSprite2D
@export var bullet_scene: PackedScene
@export var audio_fire: AudioStreamPlayer
@export var audio_run: AudioStreamPlayer

func _ready():
	GameManager.game_overed.connect(handle_game_over)

func _process(_delta):
	if velocity != Vector2.ZERO and GameManager.game_state == GameManager.GameState.PLAYING:
		if not audio_run.playing:
			audio_run.play()
	else:
		audio_run.stop()

func _physics_process(delta: float) -> void:
	if GameManager.game_state == GameManager.GameState.PLAYING:
		var speed = game_controller.player_base_speed * 100 * delta
		velocity = Input.get_vector("left", "right", "up", "down") * speed

		if velocity == Vector2.ZERO:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
			animated_sprite_2d.flip_h = velocity.x < 0

		move_and_slide()

		if Input.is_action_just_pressed("fire"):
			var bullet = bullet_scene.instantiate()
			bullet.position = position + Vector2(6, 6)
			get_tree().current_scene.add_child(bullet)
			audio_fire.play()

func handle_game_over():
	animated_sprite_2d.play("game_over")
