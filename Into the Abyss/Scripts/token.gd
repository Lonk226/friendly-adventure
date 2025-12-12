extends Node2D

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		singleton.token_collected.emit()
		$Hitbox/CollisionShape2D.disabled = true
		$AnimatedSprite2D.hide()
		$CPUParticles2D.emitting = true
		await get_tree().create_timer(0.3).timeout
		queue_free()
