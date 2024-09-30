extends CharacterBody2D

signal health_depleted

signal level_up

@export var joystick_mode : bool
@export var joystick : VirtualJoystick

const DAMAGE_RATE = 50.0
var max_health = Status.hp
var cur_health = max_health
var SPEED = Status.move_spd

#레벨업 등으로 스텟이 변경됐을때 호출
func refresh_stat():
	var add_hp = Status.hp - max_health
	max_health = Status.hp
	cur_health += add_hp
	SPEED = Status.move_spd
	
func _ready():
	if joystick != null && !joystick_mode:
		joystick.hide()
		$Camera2D.position.y = 0

func _physics_process(delta):
	if joystick_mode:
		velocity = joystick.output * SPEED
	else:
		var direction = Input.get_vector("left", "right", "up", "down")
		velocity = direction * SPEED
		
	if abs(velocity.x) > 0:
		if velocity.x > 0:
			%Soldier.scale = Vector2(1, 1)
		else:
			%Soldier.scale = Vector2(-1, 1)
		
	move_and_slide()
	
	if velocity.length() > 0:
		%Soldier.play_walk_animation()
	else :
		%Soldier.play_idle_animation()
	var overlapping_mobs = %HitBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		#방어력 계산
		cur_health -= DAMAGE_RATE * overlapping_mobs.size() * delta * (1 - Status.def / 100)
		$ProgressBar.value = cur_health / max_health * 100
		$ProgressBar/Label.text = str(int(cur_health)) + "/" + str(int(max_health))
		# test 무적
		#if cur_health <= 0.0:
			#health_depleted.emit()

func _on_game_level_up():
	print_debug("player level up ")
	level_up.emit()
	refresh_stat()
