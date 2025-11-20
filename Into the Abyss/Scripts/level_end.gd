extends Area2D

@onready var player = get_tree().get_first_node_in_group("Player")

@onready var one: Sprite2D = $Sprite2D
@onready var two: Sprite2D = $Sprite2D2
@onready var three: Sprite2D = $Sprite2D3
@onready var four: Sprite2D = $Sprite2D4
@onready var five: Sprite2D = $Sprite2D5

func _process(delta: float) -> void:
	one.rotation += .100 * delta
	three.rotation += .300 * delta
	five.rotation += .500 * delta
	two.rotation += -.200 * delta
	four.rotation += -.400 * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var current_scene = get_tree().current_scene.scene_file_path
		var next_level_num = current_scene.to_int() + 1
		var next_level_path = "res://Scenes/Levels/level_" + str(next_level_num) + ".tscn"
		singleton.sc_start.emit()
		player.frozen = true
		print(next_level_path)
		var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(player, "position", global_position, 0.3)
		var tween2 = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		tween2.tween_property(player, "scale", Vector2.ZERO, 0.3)
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(next_level_path)
