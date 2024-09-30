extends Area2D

var attack_range = 300
var default_attack_speed = 1.5
var base_dmg = 20
var dmg_percent = 1.2
var knockback_force = 200

var max_combo = 2
var cur_combo = 0

var projectile = load("res://Scene/skill/warrior/slash/aura.tscn")

@export var attacking: bool = false
@export var aura_slash: bool = false
@onready var player = get_node("/root/Game/Player")

func set_range():
	var circle_shape = $Range.shape as CircleShape2D
	circle_shape.radius = attack_range
	
func set_attack_time():
	%AttackTimer.wait_time = default_attack_speed / Status.atk_spd
	
func _ready() -> void:
	set_range()
	set_attack_time()
	
func check_enemy():
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)
	else:
		global_rotation_degrees = 0
	
func _physics_process(delta):
	if !attacking:
		check_enemy()
		
	if aura_slash:
		aura_slash = false
		sword_aura()

func _on_attack_timer_timeout() -> void:
	%AnimationPlayer.play("slash_" + str(cur_combo))
	cur_combo += 1
	if cur_combo > max_combo:
		cur_combo = 0
		
func sword_aura():
	var shooting_bullet = projectile.instantiate()
	shooting_bullet.global_position = %AuraPoint.global_position
	shooting_bullet.global_rotation = %AuraPoint.global_rotation
	%AuraPoint.add_child(shooting_bullet)

func _on_attack_area_body_entered(body: Node2D) -> void:
	if attacking && body.has_method("take_damage"):
		body.take_damage(Status.atk * dmg_percent + base_dmg)
		body.knockback(body.position - player.position, knockback_force)
		 #* dmg_percent + base_dmg

func _on_player_level_up() -> void:
	set_attack_time()
