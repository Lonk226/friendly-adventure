extends Node2D

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

func _ready() -> void:
	singleton.sc_start.connect(play_start)
	singleton.sc_end.connect(play_end)
	color_rect.position.x = 768

func play_start():
	animation.play("Start")
	
func play_end():
	animation.play("End")
