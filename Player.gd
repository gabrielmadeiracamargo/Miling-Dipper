extends Area2D

signal hit

#export (PackedScene) var Main

export var speed = 100
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	hide()

var velocity = Vector2.ZERO
func _process(delta):
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") 
	
	if Input.get_action_strength("ui_shift"): 
		speed = 150
		$Particles2D.speed_scale = 2
	else: 
		speed = 100
		$Particles2D.speed_scale = 1
	
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

	if velocity.x != 0 && Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") :
		$Particles2D.emitting = true
		$AnimatedSprite.animation = "nadar"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
		$AnimatedSprite.rotation_degrees = 0
		$Particles2D.position.x = -7
	if velocity.y != 0 && Input.get_action_strength("ui_down") || Input.get_action_strength("ui_up") :
		$Particles2D.emitting = true
		$AnimatedSprite.rotation_degrees = 90
		$AnimatedSprite.flip_h = velocity.y < 0
		$Particles2D.position.x = 3
		$Particles2D.position.y = 3
		

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
	show()
	$CollisionShape2D.disabled = false
