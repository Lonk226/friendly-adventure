extends Control

@export var text: String
var highlighted: bool = false
signal hovered(nodename)

func _process(delta: float) -> void:
	$Label.text = text
	if highlighted:
		$ColorRect3.visible = true
		$ColorRect4.visible = true
	else:
		$ColorRect3.visible = false
		$ColorRect4.visible = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if not $"../..".fading:
		highlighted = true
		hovered.emit(self)
