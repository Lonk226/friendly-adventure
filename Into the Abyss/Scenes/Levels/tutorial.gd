extends Node2D


func _on_move_a_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var tween = get_tree().create_tween()
		tween.tween_property($Move, "modulate", Color.WHITE, 0.25)

func _on_move_a_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var tween = get_tree().create_tween()
		tween.tween_property($Move, "modulate", Color.TRANSPARENT, 0.25)

func _on_jump_a_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var tween = get_tree().create_tween()
		tween.tween_property($Jump, "modulate", Color.WHITE, 0.25)

func _on_jump_a_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var tween = get_tree().create_tween()
		tween.tween_property($Jump, "modulate", Color.TRANSPARENT, 0.25)
