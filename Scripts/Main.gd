extends Node2D


const obj_fruit1 = preload("res://Scenes/Fruit1.tscn")
const obj_fruit2 =  preload("res://Scenes/Fruit2.tscn")
const obj_fruit3 = preload("res://Scenes/Fruit3.tscn")
const obj_fruit4 =  preload("res://Scenes/Fruit4.tscn")
const obj_fruit5 =  preload("res://Scenes/Fruit5.tscn")
const obj_fruit6 =  preload("res://Scenes/Fruit6.tscn")
const obj_fruit7 =  preload("res://Scenes/Fruit7.tscn")
var shapes =[]
var rng = RandomNumberGenerator.new()
var rnd = RandomNumberGenerator.new()
var shape_index:int  = 1

var window_width = OS.get_window_size().x
var timer = 0
var score

func new_game():
	shapes=[obj_fruit1,obj_fruit2,obj_fruit3,obj_fruit4,obj_fruit5,obj_fruit6,obj_fruit7]
	rnd.randomize()
	rng.randomize()

	
func _process(delta):

	pass

	shapes=[obj_fruit1,obj_fruit2,obj_fruit3,obj_fruit4,obj_fruit5,obj_fruit6,obj_fruit7]
	
	timer += delta
	if timer > 1:
		rng.randomize()
		timer = 0

		spawn(rng.randf_range(64, window_width - 64), rng.randf_range(100, 500))


func spawn(location: float, speed: float):
#TODO: fix array index 0 throwing error 
	shape_index = rnd.randi_range(1,6)
	var fruit = shapes[shape_index].instance()
	fruit.velocity = Vector2(0, speed)
	fruit.position = self.position + Vector2(location, 0)
	get_parent().add_child(fruit)

func game_over():
	$HUD.show_game_over()
