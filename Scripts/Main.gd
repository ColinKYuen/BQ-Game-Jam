extends Node2D

const obj_fruit = preload("res://Scenes/GoodFruit.tscn")
var rng = RandomNumberGenerator.new()
var window_width = OS.get_window_size().x
var timer = 0
var score

func _ready():
	new_game()

func new_game():
	$HUD.show_message("Get Ready")
	
	rng.randomize()
	spawn(rng.randf_range(64, window_width - 64), rng.randf_range(100, 500))
	
func _process(delta):
	pass

func spawn(location: float, speed: float):
	var fruit = obj_fruit.instance()
	fruit.velocity = Vector2(0, speed)
	fruit.position = self.position + Vector2(location, 0)
	get_parent().add_child(fruit)

func game_over():
	$HUD.show_game_over()
