extends Area2D

signal hit

export var speed: float = 100.0
var screen_size
var target = Vector2()
var is_running = false

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2()
	print(speed)
	
	if position.distance_to(target) > 10:
		velocity = target - position

	#velocity.x += Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	#velocity.y += Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") 

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		velocity.y += 10
		$AnimatedSprite.play()
	else:
		velocity.y += 12		
		$AnimatedSprite.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _on_Player_body_entered(_body):
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true) 
	yield(get_tree().create_timer(0.2), "timeout")
	hide()
	yield(get_tree().create_timer(0.2), "timeout")	
	show()
	yield(get_tree().create_timer(0.2), "timeout")
	hide()
	yield(get_tree().create_timer(0.2), "timeout")
	$CollisionShape2D.set_deferred("disabled", false)   
	show()

func start(pos): #
	position = pos
	target = pos
	show()
	$CollisionShape2D.disabled = false

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position


func _on_RunButton_pressed():
	speed += 35
	$Particles2D.speed_scale = 2


func _on_StopButton_pressed():
	speed -= 17.5
	$Particles2D.speed_scale = 1
