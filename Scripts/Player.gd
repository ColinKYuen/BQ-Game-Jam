extends KinematicBody2D

var speed : int = 500
var screen_size
# the player should be 16 by 16, which is the default size 

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	
	if Input.is_action_pressed("move_left"):
		position.x -= speed * delta
	if Input.is_action_pressed("move_right"):
		position.x += speed * delta
	
	position.x = clamp(position.x, 0, screen_size.x)
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position.x = clamp(position.x, 0, screen_size.x)
