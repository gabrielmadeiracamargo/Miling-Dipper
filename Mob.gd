extends RigidBody2D

export var min_speed = 100
export var max_speed = 150

func _ready(): 
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
