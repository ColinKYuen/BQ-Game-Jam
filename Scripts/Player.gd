extends KinematicBody2D

var speed : int = 300
var lives : int = 3

const dash_double_tap_within: float = 0.85
const dash_duration: float = 0.3
const dash_speed: int = 900
const norm_speed: int = 300
var is_dashing: bool = false
var dash_timer: float = 0
var dash_taps: int = 0
var dash_cooldown: float = 2
var dash_on_cooldown: bool = false
var last_tap_right: bool = false

func _physics_process(delta):
	check_dash(delta)

	if is_dashing:
		if last_tap_right:
			position.x += speed * delta
		else:
			position.x -= speed * delta
	else:
		if Input.is_action_pressed("move_right"):
			position.x += speed * delta
		if Input.is_action_pressed("move_left"):
			position.x -= speed * delta

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
		speed = dash_speed

	if is_dashing:
		dash_timer += delta
		if dash_timer >= dash_duration:
			is_dashing = false
			dash_timer = 0
			speed = norm_speed
			dash_on_cooldown = true
