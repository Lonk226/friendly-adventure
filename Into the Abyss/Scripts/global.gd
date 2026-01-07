extends Node2D

signal bubble_bounce(bubble_location)
signal token_collected()
signal sc_start()
signal sc_end()

var reset_position: Vector2
var camera_reset_position: Vector2

var full_token_count: int = 0

var waiting_for_godot: bool = false
var dead: bool = false
var cam_disabled: bool = false
