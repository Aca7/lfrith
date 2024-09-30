extends ProjectileShooter

func _ready():
	#defalut setting
	pierce = 0
	bullet_speed = 800
	bullet_range = 1000
	target_range = 1000
	default_shooting_speed = 1.1
	projectile = load("res://Scene/skill/archer/piercing_shot/arrow.tscn")
	set_range()
	set_shooting_time()

func _physics_process(delta):
	check_enemy()

func _on_player_level_up():
	set_shooting_time()

func _on_shoot_timer_timeout():
	shoot()

func shoot():
	for i in 3:
		var shooting_bullet = projectile.instantiate()
		shooting_bullet.set_bullet(bullet_range, bullet_speed, 0, 1.2, pierce)
		shooting_bullet.scale = Vector2.ONE * bullet_scale

		shooting_bullet.global_position = %ShootingPoint.global_position
		shooting_bullet.global_rotation = %ShootingPoint.global_rotation + deg_to_rad(-30 * (i - 1))
		%ShootingPoint.add_child(shooting_bullet)
