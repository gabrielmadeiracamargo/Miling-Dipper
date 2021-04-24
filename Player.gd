extends Area2D

signal hit

export var speed = 100
var velocity2 = Vector2.ZERO
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	#hide()

func _process(delta):
	var velocity = Vector2.ZERO
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") 
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if velocity.x != 0:
		$AnimatedSprite.animation = "nadar"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
		$AnimatedSprite.rotation_degrees = 0
	if velocity.y != 0:
		$AnimatedSprite.rotation_degrees = 90
		$AnimatedSprite.flip_h = velocity.y < 0


func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true) #desativar quando for seguro

func start(pos): #
	position = pos
	show()
	$CollisionShape2D.disabled = false

