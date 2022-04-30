extends KinematicBody2D

var window_width = OS.get_window_size().x

var speed : int = 300
var lives : int = 3
var screen_size

const dash_double_tap_within: float = 0.85
const dash_duration: float = 0.3
const dash_speed_mult: int = 3
var norm_speed: int = 300
var is_dashing: bool = false
var dash_timer: float = 0
var dash_taps: int = 0
var dash_cooldown: float = 2
var dash_on_cooldown: bool = false
var last_tap_right: bool = false

var is_game_started: bool = false

func _ready():
	screen_size = get_viewport_rect().size

func new_game():
	is_game_started = true

func _physics_process(delta):
	if not is_game_started:
		$AnimatedSprite.stop()
		return

	var velocity = Vector2.ZERO # The player's movement vector.
	check_dash(delta)

	if is_dashing:
		if last_tap_right:
			position.x += speed * delta
			
		else:
			position.x -= speed * delta
	else:
		if Input.is_action_pressed("move_right"):
			position.x += speed * delta
			velocity.x += 3
		if Input.is_action_pressed("move_left"):
			position.x -= speed * delta
			velocity.x -= 3
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.set_frame(0)
		$AnimatedSprite.stop()
	
	# flips the character when it is walking
	# the rabbit character is symmetric, so the flipping cannot be 
	# detected by eye, but if we decide to have another character
	# that is not symmetric, the flipping should be more obvious. 
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	
	var player_width = get_node("Hitbox").get_shape().get_extents().x
	var max_right = window_width - player_width
	
	if position.x > max_right:
		position.x = max_right
	elif position.x < player_width:
		position.x = player_width
		
func check_dash(delta):
	if dash_on_cooldown:
		dash_timer += delta
		if dash_timer <= dash_cooldown:
			return
		else:
			dash_timer = 0
			dash_on_cooldown = false

	if Input.is_action_just_pressed("move_right") and not is_dashing:
		if last_tap_right:
			dash_taps += 1
		else:
			dash_taps = 1
		last_tap_right = true
	if Input.is_action_just_pressed("move_left") and not is_dashing:
		if not last_tap_right:
			dash_taps += 1
		else:
			dash_taps = 1
		last_tap_right = false

	if dash_taps > 0 and not is_dashing:
		dash_timer += delta
		if dash_timer > dash_double_tap_within:
			dash_timer = 0
			dash_taps = 0

	if dash_taps >= 2 and not is_dashing:
		is_dashing = true
		dash_timer = 0
		dash_taps = 0
		speed = norm_speed * dash_speed_mult

	if is_dashing:
		dash_timer += delta
		if dash_timer >= dash_duration:
			is_dashing = false
			dash_timer = 0
			speed = norm_speed
			dash_on_cooldown = true
