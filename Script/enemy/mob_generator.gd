extends CharacterBody2D

var mob_speed = 300
var mob_health = 250
var mob_exp = 50

var mob_type = 0
var mob_dir : Vector2
var mob_name = "slime"
var mob_scale = 1

var is_mob_dead = false
var is_mob_konckback = false

var animator

@onready var player = get_node("/root/Game/Player")

func _ready():
	if mob_type == 1 :
		mob_dir = global_position.direction_to(player.global_position)
		set_collision_layer_value(2, false)
		set_collision_layer_value(3, true)
		set_collision_mask_value(2, false)
		set_collision_mask_value(3, true)
	
func init(type, speed, health, exp, name, scale):
	mob_type = type
	mob_speed = speed
	mob_health = health
	mob_exp = exp
	mob_name = name
	mob_scale = scale
	var mob_path = "res://Scene/charactor/mob/"+mob_name+".tscn"
	animator = load(mob_path).instantiate()
	add_child(animator)
	animator.play_walk()
	
	
func _physics_process(delta):
	if !is_mob_dead and !is_mob_konckback:
		var direction : Vector2
		if mob_type == 0:
			direction = global_position.direction_to(player.global_position)
		elif mob_type == 1:
			direction = mob_dir

		if direction.x < 0:
			animator.scale = Vector2(-1, 1) * mob_scale
		else:
			animator.scale = Vector2(1, 1) * mob_scale
			
		velocity = direction * mob_speed
		
		move_and_slide()
		
	if is_mob_konckback:
		velocity = velocity.move_toward(Vector2.ZERO, 400 * delta)  # 100은 감속 비율
		if velocity == Vector2.ZERO:
			is_mob_konckback = false
		move_and_slide()

func knockback(dir: Vector2, force: float):
	is_mob_konckback = true
	velocity += dir.normalized() * force

func take_damage(damage: float):
	if !is_mob_dead:
		animator.play_hurt()
		mob_health -= damage
		if mob_health <= 0:
			is_mob_dead = true
			$CollisionShape2D.queue_free()
			await animator.play_die()
			# TODO: 경험치 처리를 여기서 하는게 맞나?
			Status.cur_exp += mob_exp
			queue_free()
