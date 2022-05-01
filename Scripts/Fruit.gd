extends Area2D

signal fruit_collected
signal fruit_hit
signal special_fruit

const max_duration: int = 1000
var life_time: float = 0
var velocity
var is_good_fruit: bool = true # Can be set on obj init
var is_special_fruit: bool = false
var is_homing: bool = false

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _physics_process(delta):
	var player = get_node("/root/Main/Player")
	var target = velocity
	var speed = velocity.length()
	if is_homing and life_time * 100 < speed:
		target = (player.position - self.position).normalized() * speed
		target.y = abs(target.y) # Force to only fall downwards
	position += target * delta
	life_time += delta
	if life_time >= max_duration:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if is_special_fruit:
			print("Special fruit collected")
			emit_signal("special_fruit")
		if is_good_fruit:
			print("Fruit collected")
			emit_signal("fruit_collected")
			pass
		else:
			print("Got hit by fruit")
			emit_signal("fruit_hit")
			pass
	queue_free()

func set_good_fruit(good_fruit_type: int):
	$AnimatedSprite.set_frame(good_fruit_type)
	
func set_bad_fruit(value: bool):
	self.is_good_fruit = value

func set_special_fruit(value: bool):
	self.is_special_fruit = value
	
func set_homing(value: bool):
	self.is_homing = value
