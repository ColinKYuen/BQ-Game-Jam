extends KinematicBody2D # -AL- tutorial says Area2D, but others
# have this instead, so it should work?

var speed : int = 500
var screen_size
# the player should be 16 by 16, which is the default size 

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 3
		position.x += speed * delta
	if Input.is_action_pressed("move_left"):
		velocity.x -= 3
		position.x -= speed * delta
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position.x = clamp(position.x, 0, screen_size.x)
	
	# flips the character when it is walking
	# the rabbit character is symmetric, so the flipping cannot be 
	# detected by eye, but if we decide to have another character
	# that is not symmetric, the flipping should be more obvious. 
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
