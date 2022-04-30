extends Area2D

signal fruit_collected
signal fruit_hit
signal special_fruit

var duration: int = 1000
var velocity
var is_good_fruit: bool = true # Can be set on obj init
var is_special_fruit: bool = false

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _physics_process(delta):
	position += velocity * delta
	duration -= delta
	if duration <= 0:
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
	
func set_bad_fruit():
	self.is_good_fruit = false

func set_special_fruit():
	self.is_special_fruit = true
	
