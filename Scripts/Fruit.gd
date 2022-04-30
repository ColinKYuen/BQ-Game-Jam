extends Area2D

signal fruit_collected
signal fruit_hit

var duration: int = 1000
var velocity: Vector2 = Vector2(0, 0)
var is_good_fruit: bool = true # Can be set on obj init

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _physics_process(delta):
	position += velocity * delta
	duration -= delta
	if duration <= 0:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if is_good_fruit:
			print("Fruit collected")
			emit_signal("fruit_collected")
			pass
		else:
			print("Got hit by fruit")
			emit_signal("fruit_hit")
			pass
	queue_free()

func set_bad_fruit():
	self.is_good_fruit = false
