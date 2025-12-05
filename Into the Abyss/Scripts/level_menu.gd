extends CanvasLayer

var on: bool

func show_menu():
	show()
	var tween = get_tree().create_tween()
	tween.tween_property($Node2D, "modulate", Color.WHITE, 0.2)
	await get_tree().create_timer(0.2).timeout
	on = true
	show()

func hide_menu():
	show()
	var tween = get_tree().create_tween()
	tween.tween_property($Node2D, "modulate", Color.TRANSPARENT, 0.2)
	await get_tree().create_timer(0.2).timeout
	on = false
	hide()
