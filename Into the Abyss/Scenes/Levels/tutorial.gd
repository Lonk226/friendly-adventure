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

func _on_roll_a_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var tween = get_tree().create_tween()
		tween.tween_property($Roll, "modulate", Color.WHITE, 0.25)

func _on_roll_a_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var tween = get_tree().create_tween()
		tween.tween_property($Roll, "modulate", Color.TRANSPARENT, 0.25)

func _on_lja_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var tween = get_tree().create_tween()
		tween.tween_property($"Long Jump", "modulate", Color.WHITE, 0.25)

func _on_lja_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var tween = get_tree().create_tween()
		tween.tween_property($"Long Jump", "modulate", Color.TRANSPARENT, 0.25)

func _on_wja_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var tween = get_tree().create_tween()
		tween.tween_property($"Wall Jump", "modulate", Color.WHITE, 0.25)

func _on_wja_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var tween = get_tree().create_tween()
		tween.tween_property($"Wall Jump", "modulate", Color.TRANSPARENT, 0.25)

func _on_dive_a_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var tween = get_tree().create_tween()
		tween.tween_property($"Dive", "modulate", Color.WHITE, 0.25)

func _on_dive_a_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var tween = get_tree().create_tween()
		tween.tween_property($"Dive", "modulate", Color.TRANSPARENT, 0.25)

func _on_sda_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var tween = get_tree().create_tween()
		tween.tween_property($"Super Dash", "modulate", Color.WHITE, 0.25)

func _on_sda_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var tween = get_tree().create_tween()
		tween.tween_property($"Super Dash", "modulate", Color.TRANSPARENT, 0.25)
