extends Node


func _on_ship_shoot(Bullet: Variant, direction: Variant, location: Variant, bullet_velocity: Vector2) -> void:
	var spawned_bullet = Bullet.instantiate()
	add_child(spawned_bullet)
	spawned_bullet.rotation = direction
	spawned_bullet.position = location
	spawned_bullet.velocity = bullet_velocity.rotated(direction)
