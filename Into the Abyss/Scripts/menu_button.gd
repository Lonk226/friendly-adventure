extends Control

@export var text: String
var highlighted: bool = false
var selected: bool = false
signal hovered(nodename)
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	$Label.text = text
	if highlighted:
		anim.play("On")
		anim.scale = Vector2(1,1)
	else:
		anim.play("Off")
		anim.scale = Vector2(0.9,0.9)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if not $"../..".fading:
		hovered.emit(self)

func select():
	$CPUParticles2D.emitting = true
	$CPUParticles2D2.emitting = true
	# play a selction animation on the button
