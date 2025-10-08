extends Control

func _ready() -> void:
	ScreenTransition.color_rect.position.x = 768

func _on_continue_pressed() -> void:
	print("continue game")

func _on_new_game_pressed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($VBoxContainer, "modulate", Color.TRANSPARENT, 1)
	await get_tree().create_timer(1).timeout
	ScreenTransition.color_rect.position.x = 0
	await get_tree().create_timer(0.01).timeout
	get_tree().change_scene_to_file('res://Scenes/the_lab.tscn')

func _on_load_game_pressed() -> void:
	print("load a save file")

func _on_options_pressed() -> void:
	print("go to options menu")

func _on_extras_pressed() -> void:
	print("find extra content")

func _on_quit_pressed() -> void:
	get_tree().quit()
