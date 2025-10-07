extends Control

var fading = false

func _ready() -> void:
	modulate = Color.WHITE

func _process(delta: float) -> void:
	if Input.is_anything_pressed() and not fading:
		$AnimationPlayer.play("fade")
		fading = true
		await get_tree().create_timer(1.5).timeout
		queue_free()
