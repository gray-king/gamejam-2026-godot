extends CharacterBody2D

var rng = RandomNumberGenerator.new()
var moving : bool = false

var speed : float
var direction : Vector2
var directionChoice = [Vector2.LEFT, Vector2.RIGHT]
var currentDirection : Vector2

func move(speed, direction, delta: float):
	moving = true
	
	# flip sprite if needed
	if direction != currentDirection:
		scale.x *= -1
	# once check is done, update correct direction
	currentDirection = direction
	
	for i in range(rng.randf_range(30,200)):
		position += direction.normalized() * speed * delta
		await get_tree().process_frame
	await get_tree().create_timer(rng.randf_range(2,5)).timeout
	moving = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not moving:
		speed = rng.randf_range(50,150)
		direction = directionChoice[randi() % 2] # chooses left or right
		move(speed, direction, delta)
