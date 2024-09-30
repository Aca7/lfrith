extends Area2D

func _ready():
	$AnimationPlayer.play("explosion")

# TODO : 이 방식으로 지우는게 맞나.. 최적화 필요
func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(Status.atk * 0.5)
