extends Control

var cooling_down: bool = false
var cooldown: float = 0.2

func _ready() -> void:
	get_tree().get_first_node_in_group("MenuButton").highlighted = true
	for button in get_tree().get_nodes_in_group("MenuButton"):
		button.hovered.connect(clear)

func _process(delta: float) -> void:
	$"Mouse Tracker/CollisionShape2D".global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("start") and $"Title Screen" == null:
		if $VBoxContainer/Continue.highlighted:
			print("continue game")
		elif $"VBoxContainer/New Game".highlighted:
			var tween = get_tree().create_tween()
			tween.tween_property($VBoxContainer, "modulate", Color.TRANSPARENT, 1)
			await get_tree().create_timer(1).timeout
			ScreenTransition.color_rect.position.x = 0
			await get_tree().create_timer(0.01).timeout
			get_tree().change_scene_to_file('res://Scenes/the_lab.tscn')
		elif $"VBoxContainer/Load Game".highlighted:
			print("load a save file")
		elif $VBoxContainer/Options.highlighted:
			print("go to options menu")
		elif $VBoxContainer/Extras.highlighted:
			print("find extra content")
		elif $VBoxContainer/Quit.highlighted:
			get_tree().quit()
	if Input.is_action_pressed("up") and not cooling_down:
		cooling_down = true
		if $VBoxContainer/Continue.highlighted:
			pass
		elif $"VBoxContainer/New Game".highlighted:
			for button in get_tree().get_nodes_in_group("MenuButton"):
				button.highlighted = false
			$VBoxContainer/Continue.highlighted = true
		elif $"VBoxContainer/Load Game".highlighted:
			for button in get_tree().get_nodes_in_group("MenuButton"):
				button.highlighted = false
			$"VBoxContainer/New Game".highlighted = true
		elif $VBoxContainer/Options.highlighted:
			for button in get_tree().get_nodes_in_group("MenuButton"):
				button.highlighted = false
			$"VBoxContainer/Load Game".highlighted = true
		elif $VBoxContainer/Extras.highlighted:
			for button in get_tree().get_nodes_in_group("MenuButton"):
				button.highlighted = false
			$VBoxContainer/Options.highlighted = true
		elif $VBoxContainer/Quit.highlighted:
			for button in get_tree().get_nodes_in_group("MenuButton"):
				button.highlighted = false
			$VBoxContainer/Extras.highlighted = true
		await get_tree().create_timer(cooldown).timeout
		cooling_down = false
	if Input.is_action_pressed("down") and not cooling_down:
		cooling_down = true
		if $VBoxContainer/Continue.highlighted:
			for button in get_tree().get_nodes_in_group("MenuButton"):
				button.highlighted = false
			$"VBoxContainer/New Game".highlighted = true
		elif $"VBoxContainer/New Game".highlighted:
			for button in get_tree().get_nodes_in_group("MenuButton"):
				button.highlighted = false
			$"VBoxContainer/Load Game".highlighted = true
		elif $"VBoxContainer/Load Game".highlighted:
			for button in get_tree().get_nodes_in_group("MenuButton"):
				button.highlighted = false
			$VBoxContainer/Options.highlighted = true
		elif $VBoxContainer/Options.highlighted:
			for button in get_tree().get_nodes_in_group("MenuButton"):
				button.highlighted = false
			$VBoxContainer/Extras.highlighted = true
		elif $VBoxContainer/Extras.highlighted:
			for button in get_tree().get_nodes_in_group("MenuButton"):
				button.highlighted = false
			$VBoxContainer/Quit.highlighted = true
		elif $VBoxContainer/Quit.highlighted:
			pass
		await get_tree().create_timer(cooldown).timeout
		cooling_down = false

func clear(specific_button):
	for button in get_tree().get_nodes_in_group("MenuButton"):
		button.highlighted = false
		specific_button.highlighted = true
