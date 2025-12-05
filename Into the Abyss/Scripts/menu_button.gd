extends Control

@export var text: String
var highlighted: bool = false
var selected: bool = false
signal hovered(nodename)
@onready var main: Sprite2D = $Main
@onready var side: Sprite2D = $Side

func _process(delta: float) -> void:
	$Label.text = text
	if highlighted:
		var tween = get_tree().create_tween()
		tween.tween_property(main, "scale", Vector2(1,1), 0.1)
		var tween2 = get_tree().create_tween()
		tween2.tween_property(side, "scale", Vector2(1,1), 0.1)
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_QUAD)
		tween2.set_ease(Tween.EASE_OUT)
		tween2.set_trans(Tween.TRANS_QUAD)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(main, "scale", Vector2(0.92,0.92), 0.1)
		var tween2 = get_tree().create_tween()
		tween2.tween_property(side, "scale", Vector2(1,0), 0.1)
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_QUAD)
		tween2.set_ease(Tween.EASE_OUT)
		tween2.set_trans(Tween.TRANS_QUAD)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if not $"../..".fading:
		hovered.emit(self)

func select():
	$CPUParticles2D.emitting = true
	$CPUParticles2D2.emitting = true
	# play a selction animation on the button
	var tween = get_tree().create_tween()
	tween.tween_property(main, "scale", Vector2(1.7,1.7), 0.12)
	await get_tree().create_timer(0.1).timeout
	var tween2 = get_tree().create_tween()
	tween2.tween_property(main, "scale", Vector2(1,1), 0.08)
