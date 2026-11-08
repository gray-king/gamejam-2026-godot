extends Node2D

var internalClock : float = 0.0

var internalWarningClock : float = 0.0
var warningFlashTime : float = 0.5

var waitingTimePerStomp : float = 8.0
var dangerHeight : float = 450.0
var dropSpeed : float = 1200.0
var raiseSpeed : float = 150.0

var rng = RandomNumberGenerator.new()

@onready var gameController = self.get_parent()

# states ... 
# this is probably a horrible way of doing this but oh well
var isWaitingtoStomp : bool = true
var isStomping : bool = false
var isWaitingToRise : bool = false
var isRaising : bool = false

var stompTimer : float = 0.0
var stompGroundTime : float = 2.0

var playerDamage : int = 5 # eeeyowch !!

func _ready() -> void:
	$danger.position = Vector2(0.0, -dangerHeight)

func _process(delta: float) -> void:
	if isWaitingtoStomp:
		internalClock += delta
		internalWarningClock += delta
		
		if internalWarningClock >= warningFlashTime:
			internalWarningClock = 0.0
			if $warning.visible:
				$warning.hide()
			else:
				$warning.show()

		if internalClock >= waitingTimePerStomp:
			internalClock = 0.0
			isWaitingtoStomp = false
			isStomping = true
			$warning.hide()

	if isStomping:
		stomp(delta)
		
	if isWaitingToRise:
		stompTimer += delta
		if stompTimer >= stompGroundTime:
			isWaitingToRise = false
			isRaising = true
		
	if isRaising:
		raiseLeg(delta)
		

func stomp(delta: float) -> void:
	$danger.position.y += dropSpeed * delta

	if $danger.position.y >= 0.0:
		$danger.position.y = 0.0
		if $VisibleOnScreenNotifier2D.is_on_screen():
			gameController.stompSFX.play()
		isStomping = false
		isWaitingToRise = true
		stompTimer = 0.0
		
func raiseLeg(delta: float) -> void:
	$danger.position.y -= raiseSpeed * delta

	if $danger.position.y <= -dangerHeight:
		$danger.position.y = -dangerHeight
		isRaising = false
		isWaitingtoStomp = true
		waitingTimePerStomp = rng.randf_range(5,10)

# harm player 
func _on_danger_body_entered(body: Node2D) -> void:
	# only damage player by actively stomping on them
	if isStomping and body.is_in_group("player"): 
		body.hp -= playerDamage
		gameController.squeakSFX.play()
