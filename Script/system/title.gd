extends Node2D

func _ready():
	$Slime.play_walk()
	$HappyBoo.play_idle_animation()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scene/screen/game.tscn")
