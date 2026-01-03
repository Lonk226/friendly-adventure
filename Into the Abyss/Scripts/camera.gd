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
	if shakestrength > 0:
		shakestrength = lerpf(shakestrength, 0, shakefade * delta)
		offset = randomoffset()
	else:
		offset = Vector2.ZERO

func _on_camera_move_up_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		cam_transition(self, "global_position", Vector2(global_position.x, global_position.y - (432)), 0.5)
		player.frozen = true
		cam_transition(player, "global_position", Vector2(player.global_position.x, player.global_position.y - player_offset), 0.5)
		await get_tree().create_timer(0.6).timeout
		player.frozen = false
		if not player.wall_sliding:
			player.reset_states()
		singleton.reset_position = player.global_position

func _on_camera_move_down_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		cam_transition(self, "global_position", Vector2(global_position.x, global_position.y + (432)), 0.5)
		player.frozen = true
		cam_transition(player, "global_position", Vector2(player.global_position.x, player.global_position.y + player_offset), 0.5)
		await get_tree().create_timer(0.6).timeout
		player.frozen = false
		if not player.wall_sliding:
			player.reset_states()
		singleton.reset_position = player.global_position

func _on_camera_move_right_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		cam_transition(self, "global_position", Vector2(global_position.x + 768, global_position.y), 0.5)
		player.frozen = true
		cam_transition(player, "global_position", Vector2(player.global_position.x + player_offset, player.global_position.y), 0.5)
		await get_tree().create_timer(0.6).timeout
		player.frozen = false
		if not player.wall_sliding:
			player.reset_states()
		singleton.reset_position = player.global_position

func _on_camera_move_left_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		cam_transition(self, "global_position", Vector2(global_position.x - 768, global_position.y), 0.5)
		player.frozen = true
		cam_transition(player, "global_position", Vector2(player.global_position.x - player_offset, player.global_position.y), 0.5)
		await get_tree().create_timer(0.6).timeout
		player.frozen = false
		if not player.wall_sliding:
			player.reset_states()
		singleton.reset_position = player.global_position

func cam_transition(node, property, final_value: Vector2, duration):
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(node, property, final_value, duration)
	await tween.finished
