extends Node

signal score_added(score: int)
signal coin_added(coin_count: int)

@export var score_label: Label
@export var game_over_label: Label
@export var coin_label: Label

@export var audio_game_over: AudioStreamPlayer
@export var game_over_restart_timer: Timer

var sence_bullet_count: int = 0

var score: int = 0
var coin_count: int = 0
var not_picked_coins: int = 0

func _ready():
  GameManager.game_overed.connect(handle_game_over)

func _process(_delta):
  score_label.text = "SCORE: " + str(score)
  coin_label.text = "COIN: " + str(coin_count)

  if Input.is_action_just_pressed("ui_cancel"):
    get_tree().quit()

func trigger_add_score(points: int = 1):
  score += points
  score_added.emit(score)

func trigger_coin(coin: int = 1):
  coin_count += coin
  coin_added.emit(coin_count)

func trigger_not_picked_coin(coin: int = 1):
  not_picked_coins += coin

func handle_game_over():
  audio_game_over.play()
  game_over_label.visible = true
  game_over_restart_timer.start()

func _on_restart_game_timeout() -> void:
  get_tree().reload_current_scene()
  GameManager.trigger_game_state(GameManager.GameState.PLAYING)
