extends KinematicBody2D

var speed : int = 500
var lives : int = 3

func _physics_process(delta):
	if Input.is_action_pressed("move_left"):
		position.x -= speed * delta
	if Input.is_action_pressed("move_right"):
		position.x += speed * delta
