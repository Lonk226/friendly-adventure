extends Camera2D

@onready var player: CharacterBody2D = $"../Player"

var player_offset: float = 30

var randomstrength: float = 8
var shakefade: float = 5
var rng = RandomNumberGenerator.new()
var shakestrength: float = 0

func apply_shake():
	shakestrength = randomstrength
	
func randomoffset() -> Vector2:
	return Vector2(rng.randf_range(-shakestrength, shakestrength), rng.randf_range(-shakestrength, shakestrength))
	
func _process(delta: float) -> void:
	global_position = player.global_position
	if shakestrength > 0:
		shakestrength = lerpf(shakestrength, 0, shakefade * delta)
		offset = randomoffset()
	else:
		offset = Vector2.ZERO
