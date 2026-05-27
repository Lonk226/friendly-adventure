extends Node2D

func _ready() -> void:
	singleton.sc_end.emit()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("start"):
		singleton.sc_start.emit()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://Scenes/Levels/beneath_the_surface.tscn")
