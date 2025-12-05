extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var researcher_sprites: AnimatedSprite2D = $"The Researcher/AnimatedSprite2D"
@onready var label: Label = $"The Researcher/Label"

var researcher_on_player: bool = false
var robot_on_player: bool = false
var x_highlighted: bool = false
var cooling_down: bool = false

var cooldown: float = 0.25

func _ready() -> void:
	label.modulate = Color.TRANSPARENT
	await get_tree().create_timer(0.1).timeout
	singleton.sc_end.emit()
	get_tree().get_first_node_in_group("Level Selector").highlighted = true
	for button in get_tree().get_nodes_in_group("Level Selector"):
		button.hovered.connect(clear)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("talk") and researcher_on_player:
		bring_up_menu()
	if Input.is_action_just_pressed("start") and $"Level Menu".on and not x_highlighted:
		if $"Level Menu/Node2D/VBoxContainer/Over and Up".highlighted:
			$"Level Menu/Node2D/VBoxContainer/Over and Up".select()
			start_level("res://Scenes/Levels/over_and_up.tscn")
		if $"Level Menu/Node2D/VBoxContainer/You can Bounce".highlighted:
			$"Level Menu/Node2D/VBoxContainer/You can Bounce".select()
			start_level("res://Scenes/Levels/you_can_bounce.tscn")
	if (Input.is_action_pressed("down") or Input.is_action_pressed("up")) and $"Level Menu".on and not cooling_down:
		cooling_down = true
		if $"Level Menu/Node2D/VBoxContainer/Over and Up".highlighted:
			for button in get_tree().get_nodes_in_group("Level Selector"):
				button.highlighted = false
			$"Level Menu/Node2D/VBoxContainer/You can Bounce".highlighted = true
		elif $"Level Menu/Node2D/VBoxContainer/You can Bounce".highlighted:
			for button in get_tree().get_nodes_in_group("Level Selector"):
				button.highlighted = false
			$"Level Menu/Node2D/VBoxContainer/Over and Up".highlighted = true
		await get_tree().create_timer(cooldown).timeout
		cooling_down = false
	if (Input.is_action_just_pressed("start") and x_highlighted) or Input.is_action_just_pressed("ineedtoleave"):
		$"Level Menu".hide_menu()
		player.frozen = false
	$"Mouse Collider".global_position = get_global_mouse_position()
	if x_highlighted:
		$"Level Menu/Node2D/X/Sprite2D".frame = 0
	else:
		$"Level Menu/Node2D/X/Sprite2D".frame = 1

func _on_the_researcher_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		researcher_on_player = true
		var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(label, "modulate", Color.WHITE, 0.2)

func _on_the_researcher_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		researcher_on_player = false
		var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(label, "modulate", Color.TRANSPARENT, 0.2)

func _on_robot_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		robot_on_player = true
		var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(label, "modulate", Color.WHITE, 0.2)

func _on_robot_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		robot_on_player = false
		var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(label, "modulate", Color.TRANSPARENT, 0.2)

func bring_up_menu():
	$"Level Menu".show_menu()
	detect_collision()
	player.frozen = true

func start_level(level: String):
	singleton.sc_start.emit()
	player.frozen = true
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(player, "scale", Vector2.ZERO, 0.3)
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(level)

func _on_x_area_entered(area: Area2D) -> void:
	x_highlighted = true

func _on_x_area_exited(area: Area2D) -> void:
	x_highlighted = false

func clear(specific_button):
	for button in get_tree().get_nodes_in_group("Level Selector"):
		button.highlighted = false
		specific_button.highlighted = true

func detect_collision():
	for button in get_tree().get_nodes_in_group("Level Selector"):
		button.reset_collision()
