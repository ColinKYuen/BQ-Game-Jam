extends Node2D

const obj_fruit1 = preload("res://Scenes/Fruit1.tscn")
const obj_fruit2 =  preload("res://Scenes/Fruit2.tscn")
const obj_fruit3 = preload("res://Scenes/Fruit3.tscn")
const obj_fruit4 =  preload("res://Scenes/Fruit4.tscn")
const obj_fruit5 =  preload("res://Scenes/Fruit5.tscn")
const obj_fruit6 =  preload("res://Scenes/Fruit6.tscn")
const obj_fruit7 =  preload("res://Scenes/Fruit7.tscn")
var shapes =[]
const obj_good_fruit = preload("res://Scenes/GoodFruit.tscn")
const obj_bad_fruit = preload("res://Scenes/BadFruit.tscn")
var rng = RandomNumberGenerator.new()
var rnd = RandomNumberGenerator.new()
var shape_index:int  = 1

var window_width = OS.get_window_size().x
var timer = 0
var bad_fruit_chance = 5

var is_game_started: bool = false

func new_game():
	is_game_started = true
	shapes=[obj_fruit1,obj_fruit2,obj_fruit3,obj_fruit4,obj_fruit5,obj_fruit6,obj_fruit7]

func _process(delta):
	if is_game_started:
		timer += delta
		if timer > 1:
			rng.randomize()
			timer = 0
			spawn(rng.randf_range(0, window_width), rng.randf_range(100, 500))

func spawn(location: float, speed: float, fruit_chance: float):
	#TODO: fix array index 0 throwing error 
	var fruit
	if fruit_chance > bad_fruit_chance:
		shape_index = rnd.randi_range(1,6)
		fruit = shapes[shape_index].instance()
	else:
		fruit = obj_bad_fruit.instance()
		fruit.set_bad_fruit();

	var fruit_size = fruit.get_node("Hitbox").get_viewport_rect().size.x
	var spawn_location = min(max(fruit_size, location), (window_width - fruit_size))
	
	fruit.velocity = Vector2(0, speed)
	fruit.position = self.position + Vector2(spawn_location, 0)
	get_parent().add_child(fruit)
	
	if fruit_chance > bad_fruit_chance:
		fruit.connect("fruit_collected", $HUD, "_on_HUD_fruit_collected")
	else:
		fruit.connect("fruit_hit", $HUD, "_on_HUD_fruit_hit")

func game_over():
	$HUD.show_game_over()
