extends Node2D

@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	singleton.sc_end.emit()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("start"):
		singleton.sc_start.emit()
		var tween = get_tree().create_tween()
		tween.tween_property(camera, "global_position", Vector2(384, 672), 0.5)
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://Scenes/Levels/beneath_the_surface.tscn")
