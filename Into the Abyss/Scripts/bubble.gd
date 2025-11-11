extends Area2D

var destroyed = false
var on_player = false

func _ready() -> void:
	$AnimatedSprite2D.play("Normal")

func _process(delta: float) -> void:
	if on_player and not destroyed:
		singleton.bubble_bounce.emit()
		destroyed = true
		$AnimatedSprite2D.play("Pop")
		await get_tree().create_timer(2).timeout
		$AnimatedSprite2D.play("Reform")
		await get_tree().create_timer(0.333).timeout
		destroyed = false
		$AnimatedSprite2D.play("Normal")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		on_player = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		on_player = false
