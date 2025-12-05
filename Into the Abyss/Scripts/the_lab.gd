extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var researcher_sprites: AnimatedSprite2D = $"The Researcher/AnimatedSprite2D"
@onready var label: Label = $"The Researcher/Label"

var researcher_on_player: bool = false
var robot_on_player: bool = false
var x_highlighted: bool = false

func _ready() -> void:
	label.modulate = Color.TRANSPARENT
	await get_tree().create_timer(0.1).timeout
	singleton.sc_end.emit()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("talk") and researcher_on_player:
		bring_up_menu()
	if (Input.is_action_just_pressed("start") and x_highlighted) or Input.is_action_just_pressed("ineedtoleave"):
		$"Level Menu".hide()
		player.frozen = false
	$"Mouse Collider".global_position = get_global_mouse_position()
	if x_highlighted:
		$"Level Menu/X/Sprite2D".frame = 0
	else:
		$"Level Menu/X/Sprite2D".frame = 1

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
	$"Level Menu".show()
	player.frozen = true
	#start_level("res://Scenes/Levels/level_1.tscn")

func start_level(level):
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
