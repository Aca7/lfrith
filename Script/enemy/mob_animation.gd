extends Node2D

func play_walk():
	%AnimationPlayer.play("walk")

func play_hurt():
	%AnimationPlayer.stop()
	%AnimationPlayer.play("hurt")
	%AnimationPlayer.queue("walk")
	
func play_die():
	%AnimationPlayer.play("die")
	await %AnimationPlayer.animation_finished
