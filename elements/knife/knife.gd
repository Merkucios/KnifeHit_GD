extends CharacterBody2D


var is_flying = false
var speed = 4500.0

func _physics_process(delta : float):
	if is_flying:
		var collision = move_and_collide(speed * delta * Vector2.UP)

func throw():
	is_flying = true
