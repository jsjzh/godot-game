extends Node

signal score_added(score: int)

@export var score_label: Label
@export var game_over_label: Label

var score: int = 0
var player_base_speed: float = 80
var bullet_base_speed: float = 200
var slime_base_speed: float = 50

func _ready():
  GameManager.game_overed.connect(handle_game_over)

func _process(_delta):
  score_label.text = "SCORE: " + str(score)

func trigger_add_score(points: int):
  score += points
  score_added.emit(score)


func handle_game_over():
  game_over_label.visible = true