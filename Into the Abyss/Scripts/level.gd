extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	singleton.sc_end.emit()
	player.frozen = true
	await get_tree().create_timer(0.2).timeout
	player.frozen = false
