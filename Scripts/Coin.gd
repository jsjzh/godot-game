extends Area2D

@onready var game_controller = $"../GameController"

@export var coin_audio_picked: AudioStreamPlayer

func _ready():
		await get_tree().create_timer(2).timeout

		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE) # 使用正弦曲线，效果更平滑
		tween.tween_property(self , "position", Vector2(-216.0, -88.0), 1)
		await tween.finished
		game_controller.trigger_coin(1)
		game_controller.trigger_not_picked_coin(-1)
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		coin_audio_picked.play()
		game_controller.trigger_coin(1)
		game_controller.trigger_not_picked_coin(-1)
		hide()
		await coin_audio_picked.finished
		queue_free()
