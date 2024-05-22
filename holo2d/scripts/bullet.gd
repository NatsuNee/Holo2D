extends RigidBody2D

var sound = 0

func _on_bullet_body_entered(body):
	if sound == 0:
		$AudioStreamPlayer2D.play()
		sound = 1
	hide()

func _ready():
	var impulse = Vector2(1000, 0).rotated(rotation)
	apply_impulse(Vector2.ZERO, impulse)

func _on_AudioStreamPlayer2D_finished():
	queue_free()
