extends Node2D

@export var player: Node

var wave = 0
var wave_data = []
var spawn_position: Vector2
var mob_generator = preload("res://Scene/charactor/mob_generatior.tscn")
var distance = 900

func _ready() -> void:
	set_wave_data()
	set_timer()

func set_wave_data() -> void:
	wave_data = Data.wave_data[wave]
	spawn_position = player.global_position + Vector2(distance, 0).rotated(randf_range(0, 2 * PI))

func set_timer() -> void:
	$SpwanTimer.wait_time = wave_data.tick
	$SpwanTimer.autostart = true
	$SpwanTimer.start()
	
	$WaveTimer.wait_time = wave_data.next_wave
	$WaveTimer.autostart = true
	$WaveTimer.one_shot = true
	$WaveTimer.start()
	
	$TermTimer.wait_time = wave_data.term
	$TermTimer.one_shot = true


func _on_spwan_timer_timeout() -> void:
	var mob = mob_generator.instantiate()
	var mob_rand = randf()
	var mob_idx = -1
	
	for i in range(wave_data.mob_percent.size()):
		if mob_rand <= wave_data.mob_percent[i]:
			mob_idx = i
			break
			
	var mob_data = Data.mob_data[wave_data.mob[mob_idx]]
	mob.init(mob_data.mob_type, mob_data.speed, mob_data.health, mob_data.exp, mob_data.asset_name, mob_data.scale)
	
	if wave_data.type == "rand":
		mob.global_position = player.global_position + Vector2(distance, 0).rotated(randf_range(0, 2 * PI))
	elif wave_data.type == "swarm":
		mob.global_position = spawn_position
	
	add_child(mob)


func _on_wave_timer_timeout() -> void:
	print_debug("wave_end")
	$SpwanTimer.stop()
	$TermTimer.start()

func _on_term_timer_timeout() -> void:
	print_debug("wave_start")
	wave += 1
	set_wave_data()
	set_timer()
