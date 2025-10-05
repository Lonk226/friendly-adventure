extends Area2D

var upright: bool

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	if upright:
		collider.position.y = 5
		animated_sprite.play("Up")
	else:
		collider.position.y = -5
		animated_sprite.play("Down")
	if $RayCast2D.is_colliding():
		upright = true
	elif $RayCast2D2.is_colliding():
		upright = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player.velocity = Vector2.ZERO
		player.frozen = true
		var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(player, "scale", Vector2.ZERO, 0.2)
		await tween.finished
		tween.kill()
		player.global_position = singleton.reset_position
		player.reset_states()
		var tween_2 = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		tween_2.tween_property(player, "scale", Vector2(1,1), 0.2)
		await tween_2.finished
		tween_2.kill()
		player.frozen = false
		player.scale = Vector2(1,1)
