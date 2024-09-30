extends Area2D

class_name ProjectileShooter

var pierce = 0
var bullet_speed = 800
var bullet_range = 1000
var target_range = 1000
var default_shooting_speed = 1.2
var bullet_scale = 1
var projectile = load("res://Scene/skill/archer/piercing_shot/arrow.tscn")

func set_range():
	var circle_shape = $Range.shape as CircleShape2D
	circle_shape.radius = target_range
	
func set_shooting_time():
	%ShootTimer.wait_time = default_shooting_speed / Status.atk_spd

func check_enemy():
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		
		if %ShootTimer.paused:
			%ShootTimer.paused = false
		
		# 거리 기준으로 정렬하는 커스텀 함수 정의
		enemies_in_range.sort_custom(func(a, b): return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position))
		
		var target_enemy = enemies_in_range.front() # [0]
		look_at(target_enemy.global_position)
	else:
		# 총 멈춤 / 재정렬
		%ShootTimer.paused = true
		global_rotation_degrees = 0

func shoot():
	var shooting_bullet = projectile.instantiate()
	shooting_bullet.set_bullet(bullet_range, bullet_speed, 0, 1.2, pierce)
	shooting_bullet.scale = Vector2.ONE * bullet_scale

	shooting_bullet.global_position = %ShootingPoint.global_position
	shooting_bullet.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(shooting_bullet)
