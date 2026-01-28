extends Node2D

@export var slime_Sence: PackedScene
@export var create_slime_time: Timer

var is_game_over: bool = false

func _process(delta):
	create_slime_time.wait_time -= 0.2 * delta
	create_slime_time.wait_time = clamp(create_slime_time.wait_time, 0.5, 2)

func _on_timer_timeout() -> void:
	var slime_node = slime_Sence.instantiate()
	slime_node.position = Vector2(260, randf_range(50, 115))
	get_tree().current_scene.add_child(slime_node)
