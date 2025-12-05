extends Control

var cooling_down: bool = false
var cooldown: float = 0.15
var fading: bool = false

func _ready() -> void:
	get_tree().get_first_node_in_group("MenuButton").highlighted = true
	for button in get_tree().get_nodes_in_group("MenuButton"):
		button.hovered.connect(clear)
	$"Title Screen".off_sig.connect(detect_collision)

func _process(delta: float) -> void:
	if not $"Title Screen".fading:
		$"Title Screen".anim.play("Loop")
	$"Mouse Tracker/CollisionShape2D".global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("start") and $"Title Screen".off == true:
		fading = true
		if $VBoxContainer/Continue.highlighted:
			ScreenTransition.color_rect.position.x = 0
			singleton.sc_start.emit()
			print("continue game")
			fading = false
			$VBoxContainer/Continue.select()
		elif $"VBoxContainer/New Game".highlighted:
			ScreenTransition.color_rect.position.x = 0
			singleton.sc_start.emit()
			$"VBoxContainer/New Game".select()
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file('res://Scenes/the_lab.tscn')
		elif $"VBoxContainer/Load Game".highlighted:
			ScreenTransition.color_rect.position.x = 0
			singleton.sc_start.emit()
			print("load a save file")
			fading = false
			$"VBoxContainer/Load Game".select()
		elif $VBoxContainer/Options.highlighted:
			ScreenTransition.color_rect.position.x = 0
			singleton.sc_start.emit()
			print("go to options menu")
			fading = false
			$VBoxContainer/Options.select()
		elif $VBoxContainer/Extras.highlighted:
			ScreenTransition.color_rect.position.x = 0
			singleton.sc_start.emit()
			print("find extra content")
			fading = false
			$VBoxContainer/Extras.select()
		elif $VBoxContainer/Quit.highlighted:
			ScreenTransition.color_rect.position.x = 0
			singleton.sc_start.emit()
			$VBoxContainer/Quit.select()
			await get_tree().create_timer(0.6).timeout
			get_tree().quit()
	if Input.is_action_pressed("up") and not cooling_down and not fading and $"Title Screen".off:
		cooling_down = true
		if $VBoxContainer/Continue.highlighted:
			for button in get_tree().get_nodes_in_group("MenuButton"):
				button.highlighted = false
			$VBoxContainer/Quit.highlighted = true
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
	if Input.is_action_pressed("down") and not cooling_down and not fading and $"Title Screen".off:
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
			for button in get_tree().get_nodes_in_group("MenuButton"):
				button.highlighted = false
			$VBoxContainer/Continue.highlighted = true
		await get_tree().create_timer(cooldown).timeout
		cooling_down = false

func clear(specific_button):
	if $"Title Screen".fading or $"Title Screen".off:
		for button in get_tree().get_nodes_in_group("MenuButton"):
			button.highlighted = false
			specific_button.highlighted = true

func detect_collision():
	for button in get_tree().get_nodes_in_group("MenuButton"):
		button.reset_collision()
