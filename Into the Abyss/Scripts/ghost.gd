extends Sprite2D

var time: float = 0.25

func _ready() -> void:
	ghosting()

func set_property(tx_pos, tx_scale_x, tx_scale_y):
	position = tx_pos
	scale.x = tx_scale_x
	scale.y = tx_scale_y

func ghosting():
	var fade = get_tree().create_tween()
	fade.tween_property(self, "self_modulate", Color.TRANSPARENT, time)
	await fade.finished
	queue_free()
