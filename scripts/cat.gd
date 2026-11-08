extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var gameController = self.get_parent()

var rng = RandomNumberGenerator.new()
var moving : bool = false

var speed : float
var direction : Vector2
var directionChoice = [Vector2.LEFT, Vector2.RIGHT]
var currentDirection : Vector2 = Vector2.LEFT

var currentZone : String = "None"
var dangerTimer : float = 0.0
var stalkingSpeed : float = 200.0

var catHP : int = 5
var harmPlayer : bool = true

func move(speed, direction):
	moving = true
	
	# make cat wait for a little bit
	await get_tree().create_timer(rng.randf_range(2,5)).timeout
		
	# flip sprite if needed
	if direction != currentDirection:
		scale.x *= -1
	# once check is done, update current direction
	currentDirection = direction
	
	var duration = rng.randf_range(0.5, 2.0)
	var elapsed = 0.0

	while elapsed < duration:
		var delta = get_process_delta_time()
		position += direction.normalized() * speed * delta
		elapsed += delta
		await get_tree().process_frame

	moving = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		
	if catHP <= 0: # bye bye kitty
		self.queue_free()
	
	# if player in danger zone, deal 1 HP of damage a second
	if currentZone == "dangerZone" and harmPlayer:
		dangerTimer += delta
		if dangerTimer >= 0.5:
			player.hp -= 1 # deal damage to player
			gameController.squeakSFX.play()
			dangerTimer -= 0.5 # reset timer
			
	# if player detected, chase after them
	elif currentZone == "playerDetection":
		follow_player()
	
	# move cat around randomly
	if not moving and currentZone != "playerDetection":
		speed = rng.randf_range(50,150)
		direction = directionChoice[randi() % 2] # chooses left or right
		move(speed, direction)

# if in sight, stalk down player !
func follow_player():
	moving = false
	var direction = global_position.direction_to(player.global_position)
	var delta = get_process_delta_time()
	if direction.x < 0:
		position += Vector2.LEFT.normalized() * stalkingSpeed * delta
	else:
		position += Vector2.RIGHT.normalized() * stalkingSpeed * delta

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		
		# find which of the 3 collision bodies the player is in
		var local_shape_owner = $Area2D.shape_find_owner(local_shape_index)
		var local_shape_node = $Area2D.shape_owner_get_owner(local_shape_owner)
		
		currentZone = local_shape_node.name
		# options are playerDetection, dangerZone and biteZone

func _input(event):
	# deal damage to cat if attacked in right spot
	if Input.is_key_pressed(KEY_SPACE):
		if currentZone == "biteZone":
			catHP -= 1
			gameController.meowSFX.play()
	
	# don't damage player if crouching underneath !
	if Input.is_key_pressed(KEY_DOWN):
		harmPlayer = false
	else:
		harmPlayer = true

func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	
	var local_shape_owner = $Area2D.shape_find_owner(local_shape_index)
	var local_shape_node = $Area2D.shape_owner_get_owner(local_shape_owner)
	
	# if zones match...
	if currentZone == local_shape_node.name:
		currentZone = "None" # reset !!
