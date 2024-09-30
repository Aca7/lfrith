extends projectile
	
var knockback_force = 200
@onready var player = get_node("/root/Game/Player")

func _ready() -> void:
	bullet_speed = 400
	bullet_range = 400
	dmg_percent = 0.5
	base_dmg = 0

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(Status.atk * dmg_percent + base_dmg)
		body.knockback(body.position - player.position, knockback_force)
