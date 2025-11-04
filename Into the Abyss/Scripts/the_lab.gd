extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var researcher_sprites: AnimatedSprite2D = $"The Researcher/AnimatedSprite2D"
@onready var label: Label = $"The Researcher/Label"

var on_player: bool = false

func _ready() -> void:
	label.modulate = Color.TRANSPARENT
	await get_tree().create_timer(0.1).timeout
	singleton.sc_end.emit()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("talk") and on_player:
		singleton.sc_start.emit()
		player.frozen = true
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")

func _on_the_researcher_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		on_player = true
		var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(label, "modulate", Color.WHITE, 0.2)

func _on_the_researcher_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		on_player = false
		var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(label, "modulate", Color.TRANSPARENT, 0.2)
