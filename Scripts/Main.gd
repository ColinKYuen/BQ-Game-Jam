extends Node2D

const good_fruits = [
	preload("res://Scenes/Fruits/Banana.tscn"),
	preload("res://Scenes/Fruits/Cherry.tscn"),
	preload("res://Scenes/Fruits/DragonFruit.tscn"),
	preload("res://Scenes/Fruits/Eggplant.tscn"),
	preload("res://Scenes/Fruits/Lemon.tscn"),
	preload("res://Scenes/Fruits/Peach.tscn"),
	preload("res://Scenes/Fruits/Strawberry.tscn")
]
const obj_bad_fruit = preload("res://Scenes/BadFruit.tscn")

var rng = RandomNumberGenerator.new()

var window_width = OS.get_window_size().x
var timer = 0
var bad_fruit_chance = 5

var is_game_started: bool = false
var fruit_container

func new_game():
	is_game_started = true
	fruit_container = Node2D.new()
	fruit_container.name = "fruit_container"
	get_parent().add_child(fruit_container)

func _process(delta):
	if is_game_started:
		timer += delta
		if timer > 1:
			rng.randomize()
			timer = 0
			spawn(rng.randf_range(0, window_width), rng.randf_range(100, 500), rng.randf_range(1, 100))

func spawn(location: float, speed: float, fruit_chance: float):
	var spawn_fruit
	if fruit_chance > bad_fruit_chance:
		var good_fruit_index = rng.randi_range(0, good_fruits.size() - 1)
		spawn_fruit = good_fruits[good_fruit_index].instance()
	else:
		spawn_fruit = obj_bad_fruit.instance()
		spawn_fruit.set_bad_fruit();

	var fruit_size = spawn_fruit.get_node("Hitbox").get_viewport_rect().size.x
	var spawn_location = min(max(fruit_size, location), (window_width - fruit_size))
	
	spawn_fruit.velocity = Vector2(0, speed)
	spawn_fruit.position = self.position + Vector2(spawn_location, 0)
	get_parent().get_node("fruit_container").add_child(spawn_fruit)
	
	if fruit_chance > bad_fruit_chance:
		spawn_fruit.connect("fruit_collected", $HUD, "_on_HUD_fruit_collected")
	else:
		spawn_fruit.connect("fruit_hit", $HUD, "_on_HUD_fruit_hit")

func game_over():
	is_game_started = false
	fruit_container.queue_free()
	$HUD.show_game_over()
