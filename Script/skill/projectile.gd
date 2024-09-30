extends Area2D

class_name projectile

var bullet_speed = 0
var bullet_range = 0
var bullet_pierce = 0
var base_dmg = 0
var travelled_distance = 0
var dmg_percent = 1

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * bullet_speed * delta
	travelled_distance += bullet_speed * delta
	if travelled_distance > bullet_range:
		queue_free()

func _on_body_entered(body):
	if bullet_pierce == 0:
		queue_free()
	else:
		bullet_pierce -= 1

	if body.has_method("take_damage"):
		body.take_damage(Status.atk * dmg_percent + base_dmg)

func set_bullet(range, speed, dmg, percent, pierce):
	bullet_range = range
	bullet_speed = speed
	bullet_pierce = pierce
	base_dmg = dmg
	dmg_percent = percent
