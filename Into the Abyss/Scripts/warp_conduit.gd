extends StaticBody2D

@onready var player = get_tree().get_first_node_in_group("Player")

var player_on = false

func _process(delta: float) -> void:
	if player_on and Input.is_action_just_pressed("up"):
		singleton.sc_start.emit()
		player.frozen = true
		var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(player, "position", global_position, 0.3)
		var tween2 = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		tween2.tween_property(player, "scale", Vector2.ZERO, 0.3)
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://Scenes/map_screen.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_on = true
		var tween = get_tree().create_tween()
		tween.tween_property($"Label", "modulate", Color.WHITE, 0.25)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_on = true
		var tween = get_tree().create_tween()
		tween.tween_property($"Label", "modulate", Color.TRANSPARENT, 0.25)
