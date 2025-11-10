extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = get_tree().get_first_node_in_group("Camera")
@onready var jump_particles: CPUParticles2D = $"Particles/Jump Particles"
@onready var wall_particles: CPUParticles2D = $"Particles/Wall Particles"
@onready var roll_particles: CPUParticles2D = $"Particles/Roll Particles"
@onready var sideflip_particles: CPUParticles2D = $"Particles/Sideflip Particles"

var ghost_node = preload("res://Scenes/ghost.tscn")

var ground_speed: float = 230
var air_speed: float = 200
var side_flipping_speed: float = 300
var roll_speed: float = 450
var jump_height: float = 70 # height of jump
var jump_time_to_peak: float = 0.42 # length of jump
var jump_time_to_descent: float = 0.28 # length of fall
var jump_speed: float = ((2 * jump_height) / jump_time_to_peak) * -1 # speed of jump
var jump_gravity: float = ((-2 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1 # gravity while jumping
var fall_gravity: float = ((-2 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1 # gravity while falling
var terminal_velocity: float = 800
var friction: float = 15
var acceleration: float = 8
var air_acceleration: float = 15
var side_flip_acceleration: float = 50
var wall_jump_pushback: float = 350
var dive_gravity: float = 1400
var roll_gravity: float = 600
var charge_value: float = 0
var charge_up: float = 400
var goal_value: float = 0
var super_dash_speed: float = 1000

var facing_left: bool = false
var can_jump: bool = true
var buffering: bool = false
var on_ground: bool = true
var rolling: bool = false
var long_jumping: bool = false
var side_flipping: bool = false
var diving: bool = false
var can_dive: bool = false
var wall_sliding: bool = false
var ghosting: bool = false
var roll_buffering: bool = false
var maxed: bool = false
var super_dashing: bool = false
var bouncing: bool = false
var frozen: bool = false
var can_change_dash_dir: bool = false

var direct: int = 1
var dash_dir: Vector2
var token_num: int = 0

var particle_pos: Vector2

func _ready() -> void:
	singleton.bubble_bounce.connect(bubble_bounce)
	singleton.token_collected.connect(token_collect)

func _physics_process(delta: float) -> void:
	if not frozen:
		var dir := Input.get_axis("left", "right")
		if not is_on_floor() and not super_dashing:
			velocity.y += get_the_gravity() * delta
		if Input.is_action_just_pressed("jump"):
			buffering = true
			$"Buffer Timer".start()
		if Input.is_action_just_pressed("roll"):
			roll_buffering = true
			$"Buffer Timer 2".start()
		if buffering and can_jump and not super_dashing:
			if rolling:
				if not dir == 0 and not dir == direct:
					side_flip()
				else:
					long_jump()
				roll_particles.emitting = false
			else:
				jump()
			if is_on_floor():
				jump_particles.emitting = true
			buffering = false
		if velocity.y > terminal_velocity and not super_dashing:
			velocity.y = terminal_velocity
		if Input.is_action_just_released("jump") and velocity.y < 0 and not side_flipping and not long_jumping and not diving and not super_dashing and not bouncing:
			velocity.y = 0
		if not diving and not super_dashing:
			if dir:
				if is_on_floor():
					if dir == 1:
						velocity.x = min(velocity.x + acceleration, ground_speed)
					elif dir == -1:
						velocity.x = max(velocity.x - acceleration, -ground_speed)
				else:
					if side_flipping:
						if dir == 1:
							velocity.x = min(velocity.x + side_flip_acceleration, side_flipping_speed)
						elif dir == -1:
							velocity.x = max(velocity.x - side_flip_acceleration, -side_flipping_speed)
					else:
						if dir == 1:
							velocity.x = min(velocity.x + air_acceleration, air_speed)
						elif dir == -1:
							velocity.x = max(velocity.x - air_acceleration, -air_speed)
			else:
				velocity.x = move_toward(velocity.x, 0, friction)
		if is_on_floor():
			if not on_ground:
				if long_jumping:
					long_jumping = false
					velocity.x = 230 * direct
				if diving:
					if not dir:
						velocity.x = dir * 1000
					diving = false
				if super_dashing:
					super_dashing = false
					velocity = velocity/4
				reset_states()
			on_ground = true
		else:
			on_ground = false
		if rolling:
			can_jump = true
		if long_jumping:
			velocity.x = (600 * direct)
		if velocity.y > 0:
			bouncing = false
		
		roll()
		dive()
		wall_sliding_and_jumping()
		reset_coyote_jump()
		move_and_slide()
		handle_meter(delta)
	play_anim(delta)
	particle_anim()
	ghost_effect()
	
	if get_tree().current_scene.scene_file_path == "res://Scenes/the_lab.tscn":
		$UI/Label.text = str(singleton.full_token_count)
	else:
		$UI/Label.text = str(token_num)

func jump():
	velocity.y = jump_speed
	can_jump = false
	animated_sprite.scale = Vector2(0.5, 1.5)
	rolling = false

func long_jump():
	velocity.y = jump_speed * 0.7
	can_jump = false
	animated_sprite.scale = Vector2(0.5, 1.5)
	rolling = false
	long_jumping = true
	boost_charge()

func side_flip():
	velocity.y = jump_speed * 1.4
	can_jump = false
	side_flipping = true
	animated_sprite.scale = Vector2(0.5, 1.5)
	roll_particles.emitting = false
	rolling = false
	velocity.x = 300 * direct
	sideflip_particles.emitting = true
	boost_charge()
	await get_tree().create_timer(0.5).timeout
	if side_flipping:
		velocity.y = 0
		side_flipping = false

func bubble_bounce():
	reset_states()
	camera.apply_shake()
	bouncing = true
	velocity.y = jump_speed * 1.6
	can_jump = false
	animated_sprite.scale = Vector2(0.5, 1.5)
	rolling = false
	can_dive = true
	maxed = true
	goal_value = $"UI/Super Meter".max_value
	var tween = create_tween()
	tween.tween_property(self, "charge_value", $"UI/Super Meter".max_value, 0.1)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)

func play_anim(delta):
	var dir: float = Input.get_axis("left", "right")
	animated_sprite.flip_h = facing_left
	if is_on_floor():
		if super_dashing:
			animated_sprite.play("Super")
		elif rolling:
			animated_sprite.play("Roll")
		elif dir:
			animated_sprite.play("Walk")
		else:
			animated_sprite.play("Idle")
	else:
		if super_dashing:
			animated_sprite.play("Super")
		elif rolling:
			animated_sprite.play("Roll")
		elif wall_sliding:
			animated_sprite.play("Cling")
		elif diving:
			animated_sprite.play("Dive")
		elif side_flipping:
			animated_sprite.play("Flip")
		elif velocity.y < 0:
			animated_sprite.play("Jump")
		else:
			animated_sprite.play("Fall")
	if dir == 1 and not rolling and not long_jumping and not diving and not wall_sliding:
		facing_left = false
		direct = 1
	elif dir == -1 and not rolling and not long_jumping and not diving and not wall_sliding:
		facing_left = true
		direct = -1
	animated_sprite.scale.x = move_toward(animated_sprite.scale.x, 1, 2 * delta)
	animated_sprite.scale.y = move_toward(animated_sprite.scale.y, 1, 1 * delta)
	if diving:
		animated_sprite.rotation = deg_to_rad(direct * velocity.y/12)
	else:
		animated_sprite.rotation = deg_to_rad(0)

func particle_anim():
	if is_on_floor():
		jump_particles.global_position = Vector2(global_position.x, global_position.y + 16)
	if wall_sliding and not $RayCast2D.is_colliding():
		wall_particles.emitting = true
		wall_particles.direction.x = direct
	else:
		wall_particles.emitting = false
	wall_particles.position.x = direct * -8

func get_the_gravity():
	if diving:
		return dive_gravity
	if rolling:
		return roll_gravity
	elif velocity.y < 0:
		return jump_gravity
	else:
		return fall_gravity

func reset_coyote_jump():
	if is_on_floor():
		can_jump = true
		can_dive = true
		$"Coyote Timer".stop()
	else:
		if can_jump and $"Coyote Timer".is_stopped():
			$"Coyote Timer".start()

func _on_coyote_timer_timeout() -> void:
	can_jump = false

func _on_buffer_timer_timeout() -> void:
	buffering = false

func _on_buffer_timer_2_timeout() -> void:
	roll_buffering = false

func roll():
	if roll_buffering and is_on_floor() and not rolling and not super_dashing:
		roll_buffering = false
		reset_states()
		rolling = true
		boost_charge()
		roll_particles.emitting = true
		await get_tree().create_timer(0.4).timeout
		rolling = false
		roll_particles.emitting = false
		velocity.x = 230 * direct
	if rolling == true:
		velocity.x = roll_speed * direct
		if is_on_wall():
			roll_particles.emitting = false

func dive():
	if roll_buffering and not is_on_floor() and can_dive and not rolling and not wall_sliding and not $RayCast2D.is_colliding() and not $RayCast2D2.is_colliding() and not super_dashing:
		roll_buffering = false
		can_dive = false
		reset_states()
		velocity = Vector2.ZERO
		diving = true
		boost_charge()
		animated_sprite.scale = Vector2(1.3, 0.7)
		velocity.y = -300
	if diving:
		velocity.x = 500 * direct

func wall_sliding_and_jumping():
	var dir := Input.get_axis("left", "right")
	$RayCast2D.target_position.x = 16 * direct
	if ($RayCast2D.is_colliding() and dir and not is_on_floor() and velocity.y > 0 and not wall_sliding) or ((diving) and is_on_wall_only()) or (long_jumping and is_on_wall_only()) and not super_dashing:
		reset_states()
		wall_sliding = true
		flip()
	if wall_sliding:
		long_jumping = false
		velocity.y = 50
		velocity.x = -200 * direct
		if is_on_floor() or not is_on_wall():
			wall_sliding = false
		if buffering:
			wall_sliding = false
			buffering = false
			jump()
			$"Particles/Wall Jump Particles".emitting = false
			$"Particles/Wall Jump Particles".emitting = true
			boost_charge()
			velocity.x = wall_jump_pushback * direct
			return
		if roll_buffering:
			roll_buffering = false
			wall_sliding = false
			buffering = false
			velocity.x = wall_jump_pushback * direct
			can_dive = true

func flip():
	if direct == -1:
		facing_left = false
		direct = 1
	elif direct == 1:
		facing_left = true
		direct = -1

func ghost_effect():
	if ghosting == true:
		add_ghost()
	if super_dashing:
		ghosting = true
	else:
		ghosting = false

func add_ghost():
	var ghost = ghost_node.instantiate()
	if super_dashing:
		ghost.frame = 2
	else:
		ghost.frame = 18
	ghost.set_property(Vector2(position.x, position.y), scale.x * direct, scale.y)
	get_tree().current_scene.add_child(ghost)

func handle_meter(delta):
	$"UI/Super Meter".value = charge_value
	if charge_value > $"UI/Super Meter".max_value:
		charge_value = $"UI/Super Meter".max_value
	if charge_value == $"UI/Super Meter".max_value and not maxed:
		maxed = true
	if Input.is_action_just_pressed("super_dash") and maxed:
		dash_dir = super_dash_dir()
		if wall_sliding:
			dash_dir.x = direct
		super_dash()
		goal_value = 0
		var tween = create_tween()
		tween.tween_property(self, "charge_value", 0, 0.1)
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_QUAD)
		await get_tree().create_timer(0.05).timeout
		can_change_dash_dir = true
	if super_dashing:
		wall_sliding = false
		velocity.x = dash_dir.x * super_dash_speed
		velocity.y = dash_dir.y * super_dash_speed
	if can_change_dash_dir:
		if dash_dir.x and is_on_wall():
			dash_dir.x = 0

func super_dash():
	camera.apply_shake()
	maxed = false
	reset_states()
	super_dashing = true
	await get_tree().create_timer(0.25).timeout
	can_change_dash_dir = false
	can_dive = true
	super_dashing = false
	velocity = velocity/4

func super_dash_dir():
	var dir: Vector2 = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	if dir == Vector2(0,0):
		dir.x = direct
	return dir.normalized()

func reset_states():
	diving = false
	long_jumping = false
	side_flipping = false
	rolling = false
	wall_sliding = false
	super_dashing = false
	bouncing = false
	sideflip_particles.emitting = false

func token_collect():
	token_num += 1
	singleton.full_token_count += 1

func boost_charge():
	charge_value = goal_value
	goal_value += charge_up
	var tween = create_tween()
	tween.tween_property(self, "charge_value", charge_value + charge_up, 0.07)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
