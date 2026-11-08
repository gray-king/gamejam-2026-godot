extends CharacterBody2D

var speed : float = 300
var jump_speed : float = -400.0
var hp : int = 15

var direction

@onready var animatedSprite = $Sprite2D

func _process(delta: float) -> void:
	
	# animations
	if velocity == Vector2.ZERO:
		animatedSprite.play("idle")
	else:
		if direction < 0:
			animatedSprite.play("walk-left")
		elif direction > 0:
			animatedSprite.play("walk-right")
		
	if hp <= 0:
		# TODO kill player :( + game over screen
		pass
	
func get_input():
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * speed

func _physics_process(delta):
	# Add the gravity.
	velocity += get_gravity() * delta

	# Handle Jump.
	if Input.is_key_pressed(KEY_UP) and is_on_floor():
		velocity.y = jump_speed

	# Get the input direction.
	direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed

	move_and_slide()
	
