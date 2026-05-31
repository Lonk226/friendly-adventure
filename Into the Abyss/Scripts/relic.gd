extends Node2D

@export var relic_name: String
@export var relic_sprite: Texture

func _ready() -> void:
	$Sprite2D.texture = relic_sprite
