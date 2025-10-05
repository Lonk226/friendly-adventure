extends Control

func _ready() -> void:
	ScreenTransition.position.x = 768

func _on_button_pressed() -> void:
	singleton.sc_start.emit()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")


func _on_button_2_pressed() -> void:
	print("go to settings")


func _on_button_3_pressed() -> void:
	get_tree().quit()
