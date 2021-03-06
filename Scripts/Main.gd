extends Node2D

const obj_good_fruit = preload("res://Scenes/GoodFruit.tscn")
const obj_bad_fruit = preload("res://Scenes/BadFruit.tscn")
const obj_special_fruit = preload("res://Scenes/SpecialFruit.tscn")
const base_fruit_speed:int = 100
const base_bad_fruit:int = 5

var rng = RandomNumberGenerator.new()

var window_width = OS.get_window_size().x
var timer:float = 0
var bad_fruit_chance:int = 5
var special_fruit_chance = 3
var num_good_fruits:int = 6
var spawn_timer:float = 0.0
const base_spawn_delay:int = 1

var is_game_started: bool = false
var fruit_container

func new_game():
	$BackgroundMusicStart.stop()
	$BackgroundMusic.play()
	is_game_started = true
	fruit_container = Node2D.new()
	fruit_container.name = "fruit_container"
	get_parent().add_child(fruit_container)

func _process(delta):
	if is_game_started:
		spawn_timer += delta
		$Player.norm_speed = 300 + ($HUD.score * 10)
		if spawn_timer > base_spawn_delay / ((100 + $HUD.score) * 0.01):
			rng.randomize()
			spawn_timer = 0
			spawn(rng.randf_range(0, window_width), rng.randf_range(base_fruit_speed + ($HUD.score * 10), base_fruit_speed + ($HUD.score * 20)), rng.randf_range(0, 100))

func spawn(location: float, speed: float, fruit_chance: float):
	var spawn_fruit
	var bad_fruit_chance = min(base_bad_fruit + ($HUD.score * 2), 80)
	if fruit_chance <= special_fruit_chance:
	# logic: if fruit_chance <= special_fruit_chance,
	# then produce special fruit
		spawn_fruit = obj_special_fruit.instance()
		spawn_fruit.set_special_fruit(true);
	elif fruit_chance > bad_fruit_chance:
	# logic: if fruit_chance > bad_fruit_chance,
	# then produce normal fruit
		var good_fruit_type = rng.randi_range(0, num_good_fruits - 1)
		spawn_fruit = obj_good_fruit.instance()
		spawn_fruit.set_good_fruit(good_fruit_type)
	else:
	# logic: if fruit_chance <= bad_fruit_chance,
	# then produce bad fruit
		spawn_fruit = obj_bad_fruit.instance()
		spawn_fruit.set_bad_fruit(false)
		if $HUD.score > 10:
			spawn_fruit.set_homing(true)

	var fruit_size = spawn_fruit.get_node("Hitbox").get_viewport_rect().size.x * spawn_fruit.scale.x
	var spawn_location = min(max(fruit_size, location), (window_width - fruit_size))
	
	spawn_fruit.velocity = Vector2(0, speed)
	spawn_fruit.position = self.position + Vector2(spawn_location, 0)
	get_parent().get_node("fruit_container").add_child(spawn_fruit)
	
	if fruit_chance <= special_fruit_chance:
	# logic: if fruit_chance <= special_fruit_chance,
	# then produce special fruit
		spawn_fruit.connect("special_fruit", $HUD, "_on_HUD_special_fruit")
		spawn_fruit.connect("special_fruit", $Player, "_on_Player_fruit_collected")
	elif fruit_chance > bad_fruit_chance:
	# logic: if fruit_chance > bad_fruit_chance,
	# then produce normal fruit
		spawn_fruit.connect("fruit_collected", $HUD, "_on_HUD_fruit_collected")
		spawn_fruit.connect("fruit_collected", $Player, "_on_Player_fruit_collected")
	else:
	# logic: if fruit_chance <= bad_fruit_chance,
	# then produce bad fruit
		spawn_fruit.connect("fruit_hit", $HUD, "_on_HUD_fruit_hit")
		spawn_fruit.connect("fruit_hit", $Player, "_on_Player_fruit_hit")

func game_over():
	$BackgroundMusic.stop()
	$GameOver.stream.loop = false
	$GameOver.play()
	
	$BackgroundMusicStart.play()
	is_game_started = false
	$Player.is_game_started = false
	$Player.position.x = window_width / 2
	fruit_container.queue_free()
	$HUD.show_game_over()
