extends Area2D

var attack_range = 200
var default_attack_speed = 5
var base_dmg = 10
var dmg_percent = 0.5
var knockback_force = 500

@onready var player = get_node("/root/Game/Player")

func set_range():
	var circle_shape = $Range.shape as CircleShape2D
	circle_shape.radius = attack_range
	
func set_attack_time():
	%AttackTimer.wait_time = default_attack_speed / Status.atk_spd
	
func _ready() -> void:
	set_range()
	set_attack_time()

func _on_attack_timer_timeout() -> void:
	%AnimationPlayer.play("attack")
	var enemies_in_range = get_overlapping_bodies()
	for enemy in enemies_in_range:
		enemy.take_damage(Status.atk * dmg_percent + base_dmg)
		enemy.knockback(enemy.position - player.position, knockback_force)
