extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over!")
	yield($MessageTimer, "timeout")
	$Message.text = "Miling Dipper\n1.0 Version"
	$Message.show()
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	$"../RunButton".visible = false
	$"../StopButton".visible = false
	
func update_score(score):
	$ScoreLabel.text =  str(score)

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
	$"../RunButton".visible = true
	$"../StopButton".visible = true
	$StartButton/Pressed.play()
	
func hover():
	$StartButton/Hover.play()

func _on_MessageTimer_timeout():
	$Message.hide()


