extends Node

export (PackedScene) var Mob
export (PackedScene) var Bubble

var bubble_min_speed = 12
var bubble_max_speed = 25
var ishard = 0

var score : int = 0
var isnewhighscore : bool = false
var life = 0

const SAVE_DIR = "user://saves/"
var save_path = SAVE_DIR + "save.dat"

func _ready():
	randomize()
	load_highscore()

func _process(_delta):
	save_highscore()
	$Lives.text = str(life)

func game_over():
	life -= 1
	if life == 1:
		$Hit.play()
		$Player/AnimatedSprite.scale.x = 1
		$Player/CollisionShape2D.scale.x = 1
		$Player/AnimatedSprite.scale.y = 1
		$Player/CollisionShape2D.scale.y = 1 
	
	if life <= 0:
		life = 0
		$ScoreTimer.stop()
		$MobTimer.stop()
		$HUD.show_game_over()
		$DeathSound.play()
		$HighScore.show()
		$HighScore.text = "High Score:\n" + str(highscore)
		if (score >= highscore):
			$HighScore.text += "\nNew High Score!"
		get_tree().call_group("mobs", "queue_free")
		get_tree().call_group("bubbles", "queue_free")
		yield(get_tree().create_timer(2), "timeout")
		$HighScore.hide()

func new_game():
	score = 0
	life = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

func _on_StartTimer_timeout():
	$ScoreTimer.start()
	$MobTimer.start()


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
	if score % 10 == 0:
		ishard = 25
		life +=1
		if ($Player/AnimatedSprite.scale.x <= 2 && $Player/AnimatedSprite.scale.y <= 2):
			$Player/AnimatedSprite.scale.x += 0.1
			$Player/CollisionShape2D.scale.x += 0.1
			$Player/AnimatedSprite.scale.y += 0.1
			$Player/CollisionShape2D.scale.y += 0.1 
			
			$Player/AnimatedSprite.scale.x += 0.1
			$Player/CollisionShape2D.scale.x += 0.1
			$Player/AnimatedSprite.scale.y += 0.1
			$Player/CollisionShape2D.scale.y += 0.1 

func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.offset = randi() 
	var mob = Mob.instance()
	add_child(mob)
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	mob.position = $MobPath/MobSpawnLocation.position
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction 
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)

func _on_BubbleTimer_timeout():
	$BubblePath/BubbleFollow2D.offset = randi() 
	var bubble = Bubble.instance()
	add_child(bubble)
	var direction = $BubblePath/BubbleFollow2D.rotation + PI / 2
	bubble.position = $BubblePath/BubbleFollow2D.position
	direction += rand_range(-PI, PI)
	bubble.rotation = direction 
	bubble.linear_velocity = Vector2(rand_range(-5, 5), rand_range(bubble_min_speed, bubble_max_speed + ishard))
	bubble.linear_velocity = bubble.linear_velocity.rotated(direction)

var highscore : int = 0

func save_highscore() -> void:
	if score <= highscore:
		return
	else: 
		highscore = score
		isnewhighscore = true
	
	var file = File.new();
	
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, "gnevesdev")
	if error == OK:
		file.store_32(score)
		file.close()


func load_highscore():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open_encrypted_with_pass(save_path, File.READ, "gnevesdev")
		if error == OK:
			highscore = file.get_32()
			file.close()
