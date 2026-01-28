extends Node

signal score_added(score: int)

var score: int = 0
var player_base_speed: float = 80
var bullet_base_speed: float = 200
var slime_base_speed: float = 50

func trigger_add_score(points: int):
  score += points
  score_added.emit(score)
