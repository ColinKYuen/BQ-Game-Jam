extends CanvasLayer

signal start_game
signal end_game

var highscore:int = 0
var score:int = 0
var lives:int = 3
var collected_special:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	load_highscore()
	$Highscore.text = ("Highscore\n" + str(highscore))
	connect("end_game", get_parent(), "game_over")

func save_highscore():
	var file = File.new()
	file.open("user://save_game.dat", File.WRITE)
	file.store_64(highscore)
	file.close()

func load_highscore():
	var file = File.new()
	file.open("user://save_game.dat", File.READ)
	highscore = file.get_64()
	file.close()

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	$Message.text = "GAME OVER"
	$Message.show()
	$StartButton.show()
	$Instructions.show()

func reset_HUD():
	score = 0
	lives = 3
	$Life1.set_frame(0)
	$Life2.set_frame(0)
	$Life3.set_frame(0)
	$Score.text = "0"

func _on_StartButton_pressed():
	print("start pressed")
	reset_HUD()
	$StartButton.hide()
	$Message.hide()
	$Highscore.hide()
	$Score.show()
	$Fruits.hide()
	$Instructions.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Message.hide()

func _on_HUD_special_fruit():
	# logic: special fruit also gives scores that a normal fruit would
	$HitSpecialFruit.stream.loop = false
	$HitSpecialFruit.play()
	lives = min(3, lives + 1)
	print("current lives: " + str(lives))
	match (lives):
		3: 
			$Life1.set_frame(0)
		2:
			$Life2.set_frame(0)
	collected_special = true
	_on_HUD_fruit_collected()

func _on_HUD_fruit_collected():
	if collected_special:
		collected_special = false
	else:
		$HitGoodFruit.stream.loop = false
		$HitGoodFruit.play()
	score += 1
	$Score.text = str(score)
	print("current score: " + str(score))	
	if score > highscore:
		highscore = score

func _on_HUD_fruit_hit():
	lives -= 1
	print("current lives: " + str(lives))
	match (lives):
		2:
			$Life1.set_frame(1)
			$HitBadFruit.stream.loop = false
			$HitBadFruit.play()
		1:
			$Life2.set_frame(1)
			$HitBadFruit.stream.loop = false
			$HitBadFruit.play()
		_:
			# Gameover
			$Life3.set_frame(1)
			save_highscore()
			emit_signal("end_game")
			print("Gameover")
			pass
