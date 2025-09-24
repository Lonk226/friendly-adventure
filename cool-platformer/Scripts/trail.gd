extends Line2D

func _process(delta: float) -> void:
	if (get_parent().diving and not $"../RayCast2D".is_colliding()) or get_parent().long_jumping and not get_parent().is_on_floor():
		add_point(Vector2(get_parent().global_position.x, get_parent().global_position.y))
	else:
		if points:
			remove_point(0)
	if points.size() > 10:
		remove_point(0)
