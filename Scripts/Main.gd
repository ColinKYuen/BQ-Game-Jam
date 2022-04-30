extends Node2D

const obj_fruit = preload("res://Scenes/GoodFruit.tscn")

func _process(delta):
	spawn(100, 100)

func spawn(location: float, speed: float):
	var fruit = obj_fruit.instance()
	fruit.velocity = Vector2(0, speed)
	# TODO - Need to set fruit location
	fruit.position = self.position + Vector2(location, 0)
	get_parent().add_child(fruit)
