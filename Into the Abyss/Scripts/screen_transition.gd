extends Node2D

@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	singleton.sc_start.connect(play_start)
	singleton.sc_end.connect(play_end)
	position.x = 768

func play_start():
	animation.play("Start")
	
func play_end():
	animation.play("End")
