extends Node

signal score_added(score: int)

@export var score_label: Label
@export var game_over_label: Label

@export var audio_game_over: AudioStreamPlayer
@export var game_over_restart_timer: Timer

var sence_bullet_count: int = 0

var score: int = 0

func _ready():
  GameManager.game_overed.connect(handle_game_over)

func _process(_delta):
  score_label.text = "SCORE: " + str(score)

  if Input.is_action_just_pressed("ui_cancel"):
    get_tree().quit()

func trigger_add_score(points: int):
  score += points
  score_added.emit(score)

func handle_game_over():
  audio_game_over.play()
  game_over_label.visible = true
  game_over_restart_timer.start()

func _on_restart_game_timeout() -> void:
  get_tree().reload_current_scene()
  GameManager.trigger_game_state(GameManager.GameState.PLAYING)
