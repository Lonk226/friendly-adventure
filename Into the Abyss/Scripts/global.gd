extends Node2D

signal bubble_bounce()
signal token_collected()
signal sc_start()
signal sc_end()

var reset_position: Vector2 = Vector2(0,169)
var full_token_count: int = 0
