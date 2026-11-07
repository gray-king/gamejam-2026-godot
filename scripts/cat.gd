extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")

var rng = RandomNumberGenerator.new()
var moving : bool = false

var speed : float
var direction : Vector2
var directionChoice = [Vector2.LEFT, Vector2.RIGHT]
var currentDirection : Vector2 = Vector2.LEFT

var currentZone : String = "None"
var dangerTimer : float = 0.0

func move(speed, direction, delta: float):
	moving = true
		
	# flip sprite if needed
	if direction != currentDirection:
		scale.x *= -1
	# once check is done, update current direction
	currentDirection = direction
	
	for i in range(rng.randf_range(30,200)):
		position += direction.normalized() * speed * delta
		await get_tree().process_frame
	await get_tree().create_timer(rng.randf_range(2,5)).timeout
	moving = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	print(currentZone)
	
	# if player in danger zone, deal 1 HP of damage a second
	if currentZone == "dangerZone":
		dangerTimer += delta
		if dangerTimer >= 1.0:
			player.hp -= 1 # deal damage to player
			dangerTimer -= 1.0 # reset timer
	
	# move cat around randomly
	if not moving:
		speed = rng.randf_range(50,150)
		direction = directionChoice[randi() % 2] # chooses left or right
		move(speed, direction, delta)

# if in sight, stalk down player !
func follow_player():
	pass

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		
		# find which of the 3 collision bodies the player is in
		var local_shape_owner = $Area2D.shape_find_owner(local_shape_index)
		var local_shape_node = $Area2D.shape_owner_get_owner(local_shape_owner)
		
		currentZone = local_shape_node.name
		# options are playerDetection, dangerZone and biteZone

func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	
	var local_shape_owner = $Area2D.shape_find_owner(local_shape_index)
	var local_shape_node = $Area2D.shape_owner_get_owner(local_shape_owner)
	
	# if zones match...
	if currentZone == local_shape_node.name:
		currentZone = "None" # reset !!
