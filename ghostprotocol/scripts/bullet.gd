extends RigidBody2D

var sound = 0

func _on_bullet_body_entered(_body):
	if sound == 0:
		$AudioStreamPlayer2D.play()
		sound = 1
	hide()

func _on_AudioStreamPlayer2D_finished():
	queue_free()
