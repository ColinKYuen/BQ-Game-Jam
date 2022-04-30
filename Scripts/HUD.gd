extends CanvasLayer

signal start_game

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var score = 0;
var lives = 3;

# Called when the node enters the scene tree for the first time.
func _ready():
#	get_parent().get_node("GoodFruit").connect("fruit_collected", self, "_on_HUD_fruit_collected")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func _on_StartButton_pressed():
	print("start pressed")
	$StartButton.hide()
	$Message.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Message.hide()

func _on_HUD_fruit_collected():
	print("current score: " + str(int($Score.text) + 1))
	$Score.text = str(int($Score.text) + 1)
	score = int($Score.text) + 1

func _on_HUD_fruit_hit():
	print("current lives: " + str(lives - 1))
	if lives > 1:
		$Life1.set_frame(1)
	elif lives > 0:
		$Life2.set_frame(3)
	else:
		$Life3.set_frame(3)
	lives = lives - 1
