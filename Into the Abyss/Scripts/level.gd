extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	singleton.sc_end.emit()
	singleton.reset_position = player.global_position
