extends CharacterBody2D

@onready var game_controller = $"../GameController"

@export var player_animated_sprite: AnimatedSprite2D
@export var bullet_scene: PackedScene
@export var player_audio_fire: AudioStreamPlayer
@export var player_audio_run: AudioStreamPlayer
@export var player_roll_cooldown_Timer: Timer

@export var player_base_speed: float = 8000
@export var player_roll_speed: float = player_base_speed * 1.5
@export var player_bullet_max_count: int = 3
@export var player_roll_duration: float = 0.3

enum PlayerMoveType {IDLE, RUN, ROLL}

var player_move_type = PlayerMoveType.IDLE
var player_direction: Vector2 = Vector2.ZERO
var player_last_direction = 1 # 1: right, -1: left
var player_roll_timer: float = 0.0
var player_roll_direction: Vector2 = Vector2.RIGHT
var player_roll_colldownTimer: float = 1.0
var player_can_roll: bool = true
var player_is_invincible: bool = false

var BlinkTween: Tween

func _ready():
	GameManager.game_overed.connect(handle_game_over)
	player_animated_sprite.animation_finished.connect(handle_animation_finished)


# TODO 音乐待办
# func _process(_delta):
# 	if GameManager.is_game_playing() and player_move_type == PlayerMoveType.RUN:
# 		if not player_audio_run.playing:
# 			player_audio_run.play()
# 	else:
# 		player_audio_run.stop()


func _physics_process(delta: float) -> void:
	if GameManager.is_game_playing():
		match player_move_type:
			PlayerMoveType.IDLE:
				handle_idle_state(delta)
			PlayerMoveType.RUN:
				handle_run_state(delta)
			PlayerMoveType.ROLL:
				handle_roll_state(delta)


func handle_idle_state(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")

	if input_direction != Vector2.ZERO:
		input_direction = input_direction.normalized()

	player_last_direction = sign(input_direction.x) if input_direction.x != 0 else player_last_direction

	if Input.is_action_just_pressed("roll"):
		start_roll(input_direction)
	else:
		velocity = input_direction * player_base_speed * delta
		move_and_slide()
		update_animation(input_direction)
		handle_fire()


func handle_run_state(_delta):
	pass


func handle_roll_state(delta):
	player_roll_timer -= delta

	if player_roll_timer <= 0:
		end_roll()
		return

	velocity = player_roll_direction * player_roll_speed * delta

	move_and_slide()

	
func update_animation(input_direction: Vector2):
	if abs(input_direction.x) > 0.1:
		player_animated_sprite.flip_h = input_direction.x < 0

	if input_direction.length() == 0:
		player_animated_sprite.play("idle")
	else:
		player_animated_sprite.play("run")


func start_roll(direction: Vector2):
	if not player_can_roll:
		return
	player_move_type = PlayerMoveType.ROLL
	player_roll_direction = direction.normalized()
	player_roll_timer = player_roll_duration
	player_animated_sprite.play("roll")
	player_can_roll = false
	player_roll_cooldown_Timer.start(player_roll_colldownTimer)

	var tween = create_tween()
	tween.set_loops() # 无限循环
	tween.set_trans(Tween.TRANS_SINE) # 使用正弦曲线，效果更平滑
	
	# 创建闪烁动画：透明 ↔ 不透明
	tween.tween_property(player_animated_sprite, "modulate:a", 0.3, 0.1)
	tween.tween_property(player_animated_sprite, "modulate:a", 1.0, 0.1)
	
	# 保存tween引用以便停止
	BlinkTween = tween


func end_roll():
	player_move_type = PlayerMoveType.IDLE
	velocity = Vector2.ZERO

	if BlinkTween:
		BlinkTween.kill()
		BlinkTween = null
	
	# 确保材质恢复原状
	player_animated_sprite.modulate = Color(1, 1, 1, 1)


func handle_fire():
	if Input.is_action_just_pressed("fire"):
		if game_controller.sence_bullet_count < player_bullet_max_count:
			var new_bullet = bullet_scene.instantiate()
			new_bullet.position = position + Vector2(6, 6) if player_last_direction > 0 else position + Vector2(-6, 6)
			new_bullet.bullet_direction = player_last_direction
			get_tree().current_scene.add_child(new_bullet)
			game_controller.sence_bullet_count += 1
			player_audio_fire.play()


func handle_animation_finished():
	if player_move_type == PlayerMoveType.ROLL:
		end_roll()


func handle_game_over():
	player_animated_sprite.play("game_over")


func _on_roll_cooldown_timer_timeout() -> void:
	player_can_roll = true
