extends Area2D

var pierce = 0
var bullet_speed = 1200
var bullet_range = 550
var default_shooting_speed = 0.5

const BULLET = preload("res://Scene/skill/bullet.tscn")

func _ready():
	%ShootTimer.wait_time = default_shooting_speed / Status.atk_spd
	var circle_shape = $Range.shape as CircleShape2D
	circle_shape.radius = 550

func _physics_process(delta):
	
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		
		if %ShootTimer.paused:
			%ShootTimer.paused = false
			
		var target_enemy = enemies_in_range.front() # [0]
		look_at(target_enemy.global_position)
		
	else:
		# 총 멈춤 / 재정렬
		%ShootTimer.paused = true
		global_rotation_degrees = 0

	# 각도에 따라 총 뒤집기
	var rotation_degree = abs(int(rad_to_deg(rotation)) % 360)
	
	if rotation_degree > 90 && rotation_degree < 270:
		scale = Vector2(1, -1)
	else:
		scale = Vector2(1, 1)
	
func shoot():
	var shooting_bullet = BULLET.instantiate()

	shooting_bullet.set_bullet(bullet_range, bullet_speed, 0, 0.7, pierce)

	shooting_bullet.global_position = %ShootingPoint.global_position
	shooting_bullet.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(shooting_bullet)

func _on_player_level_up():
	print_debug("gun level up ")
	print_debug(%ShootTimer.wait_time)
	%ShootTimer.wait_time = default_shooting_speed / Status.atk_spd
