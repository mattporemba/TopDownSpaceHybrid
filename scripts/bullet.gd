extends Area2D

var velocity: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	position += velocity * delta
