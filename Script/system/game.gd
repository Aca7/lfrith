extends Node2D

signal level_up

@onready var player = get_node("/root/Game/Player")

## 몹 스폰 관련
func spawn_mob():
	var mob = preload("res://Scene/charactor/mob_generatior.tscn").instantiate()
	if randf() < 0.5 :
		mob.init(100, 250, 60, "piggy", 4)
	else :
		mob.init(50, 400, 50, "booger", 1)
	
	#%PathFollow2D.progress_ratio = randf()
	mob.global_position = player.global_position + Vector2(1200, 0).rotated(randf_range(0, 2*PI))
	add_child(mob)

func _on_timer_timeout():
	spawn_mob()

#TODO: UI 코드 분리
# 게임 오버 및 기타 UI 조작
func _on_player_health_depleted():
	$UI/GameOverUI.visible = true
	get_tree().paused = true

func _on_button_pressed():
	get_tree().paused = false
	print_debug("button clicked")
	get_tree().reload_current_scene()
	
# 레벨 및 경험치 조작
func _ready():
	$UI/GameUI/Exp.min_value = Status.cur_exp
	$UI/GameUI/Exp.max_value = Status.next_exp

func _process(delta):
	$UI/GameUI/Exp.value = Status.cur_exp
	#Level up check
	if Status.cur_exp >= Status.next_exp:
		Status.cur_exp = 0
		#test
		Status.next_exp += 100
		Status.level += 1
		#UI Check
		$UI/GameUI/Exp.value = 0
		$UI/GameUI/Exp.min_value = Status.cur_exp
		$UI/GameUI/Exp.max_value = Status.next_exp
		$UI/GameUI/Level_label.text = "Lv." + str(Status.level)
		get_tree().paused = true
		$UI/LevelUpUI.visible = true


#레벨 업 선택지 (임시)
func _on_level_up_choice_1_pressed():
	Status.atk += 10
	end_level_up()

func _on_level_up_choice_2_pressed():
	Status.atk_spd += 0.1
	end_level_up()

func _on_level_up_choice_3_pressed():
	Status.move_spd += 100
	end_level_up()
	
func end_level_up():
	level_up.emit()
	get_tree().paused = false
	$UI/LevelUpUI.visible = false


func _on_pause_pressed() -> void:
	$UI/StatusUI/Label.text = "Lv." + str(Status.level) + "\n"
	$UI/StatusUI/Label.text += "MAX HP : " + str(Status.hp) + "\n"
	$UI/StatusUI/Label.text += "공격력 : " + str(Status.atk) + "\n"
	$UI/StatusUI/Label.text += "방어력 : " + str(Status.def) + "\n"
	$UI/StatusUI/Label.text += "공격 속도 : " + str(Status.atk_spd) + "\n"
	$UI/StatusUI/Label.text += "이동속도 : " + str(Status.move_spd) + "\n"
	$UI/StatusUI/Label.text += "크리티컬 확률 : " + str(Status.crit_rate) + "\n"
	$UI/StatusUI/Label.text += "크리티컬 배율 : " + str(Status.crit_damage)
	get_tree().paused = true
	$UI/StatusUI.visible = true


func _on_resume_pressed() -> void:
	get_tree().paused = false
	$UI/StatusUI.visible = false
