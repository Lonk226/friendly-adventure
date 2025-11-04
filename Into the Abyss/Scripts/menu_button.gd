extends Control

@export var text: String
var highlighted: bool = false
signal hovered(nodename)
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	$Label.text = text
	if highlighted:
		anim.play("On")
	else:
		anim.play("Off")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if not $"../..".fading:
		highlighted = true
		hovered.emit(self)
