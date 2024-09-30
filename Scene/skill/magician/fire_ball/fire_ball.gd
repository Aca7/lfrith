extends ProjectileShooter

func _ready():
	#defalut setting
	pierce = 0
	bullet_speed = 300
	bullet_range = 700
	target_range = 700
	default_shooting_speed = 1.5
	projectile = load("res://Scene/skill/magician/fire_ball/ball.tscn")
	bullet_scale = Status.skills["fire_ball"]
	
	set_range()
	set_shooting_time()

func _physics_process(delta):
	check_enemy()

func _on_player_level_up():
	set_shooting_time()

func _on_shoot_timer_timeout():
	shoot()
