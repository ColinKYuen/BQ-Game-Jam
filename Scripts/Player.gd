extends KinematicBody2D

var window_width = OS.get_window_size().x

var speed : int = 500
var lives : int = 3

func _physics_process(delta):
	if Input.is_action_pressed("move_left"):
		position.x -= speed * delta
	if Input.is_action_pressed("move_right"):
		position.x += speed * delta
	
	var player_width = get_node("Hitbox").get_shape().get_extents().x
	var max_right = window_width - player_width
	
	if position.x > max_right:
		position.x = max_right
	elif position.x < player_width:
		position.x = player_width
