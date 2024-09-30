extends projectile

var explosion_effect = preload("res://Scene/skill/magician/fire_ball/explosion.tscn")

func _ready():
	$AnimationPlayer.play("Shoot")

func _on_body_entered(body):
	if bullet_pierce == 0:
		queue_free()
	else:
		bullet_pierce -= 1

	if body.has_method("take_damage"):
		body.take_damage(Status.atk * dmg_percent + base_dmg)
		
		
	for i in Status.skills["fire_ball"]:
		print_debug(i)
		var explosion = explosion_effect.instantiate()
		get_node("/root/Game").add_child(explosion)
		explosion.global_position = global_position + Vector2(30, 0).rotated(randf_range(0, 2*PI))
