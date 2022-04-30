extends Node2D

const obj_fruit = preload("res://Scenes/GoodFruit.tscn")
var timer = 0
var window_width = OS.get_window_size().x
var rng = RandomNumberGenerator.new()

func _process(delta):
	timer += delta
	if timer >= 1:
		rng.randomize()
		# TODO Get fruit object width for the min and max range
		spawn(rng.randf_range(64, window_width - 64), 100)
		timer = 0

func spawn(location: float, speed: float):
	var fruit = obj_fruit.instance()
	fruit.velocity = Vector2(0, speed)
	fruit.position = self.position + Vector2(location, 0)
	get_parent().add_child(fruit)

