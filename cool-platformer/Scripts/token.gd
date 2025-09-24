extends Node2D

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		singleton.token_collected.emit()
		queue_free()
