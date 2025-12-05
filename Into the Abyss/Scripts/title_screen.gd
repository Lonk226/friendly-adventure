extends Control

var fading: bool = false
var off: bool = false
@onready var anim: AnimationPlayer = $AnimationPlayer
signal off_sig()

func _ready() -> void:
	modulate = Color.WHITE
	$AnimationPlayer.play("RESET")

func _process(delta: float) -> void:
	if Input.is_anything_pressed() and not fading:
		$AnimationPlayer.play("fade")
		fading = true
		await get_tree().create_timer(0.3).timeout
		off_sig.emit()
		await get_tree().create_timer(0.45).timeout
		off = true
