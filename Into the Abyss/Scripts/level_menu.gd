extends CanvasLayer

var on: bool = false

func _ready() -> void:
	hide()
	$Node2D.modulate = Color.TRANSPARENT

func show_menu():
	show()
	$Node2D/ColorRect2.position = Vector2(307,55)
	var tween = get_tree().create_tween()
	tween.tween_property($Node2D, "modulate", Color.WHITE, 0.2)
	var tween2 = get_tree().create_tween()
	tween2.tween_property($Node2D/ColorRect2, "position", Vector2(500,55), 0.5)
	await get_tree().create_timer(0.2).timeout
	on = true
	$Node2D/ColorRect2.position = Vector2(500,55)
	show()

func hide_menu():
	show()
	var tween = get_tree().create_tween()
	tween.tween_property($Node2D, "modulate", Color.TRANSPARENT, 0.2)
	await get_tree().create_timer(0.2).timeout
	on = false
	$Node2D/ColorRect2.position = Vector2(307,55)
	hide()
