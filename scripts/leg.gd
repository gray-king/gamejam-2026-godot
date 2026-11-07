extends Node2D

var internalClock : float = 0.0
var waitingTimePerStomp : float = 8.0
var dangerHeight : float = 450.0
var dropSpeed : float = 1200.0
var raiseSpeed : float = 150.0

var isStomping : bool = false
var isWaitingToRise : bool = false
var isRaising : bool = false

var stompTimer : float = 0.0
var stompGroundTime : float = 2.0

func _ready() -> void:
	$danger.position = Vector2(0.0, -dangerHeight)

func _process(delta: float) -> void:
	if not isStomping: # i.e. if out of sight and waiting
		internalClock += delta

		if internalClock >= waitingTimePerStomp:
			internalClock = 0.0
			isStomping = true

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
		isStomping = false
		isWaitingToRise = true
		stompTimer = 0.0
		
func raiseLeg(delta: float) -> void:
	$danger.position.y -= raiseSpeed * delta

	if $danger.position.y <= -dangerHeight:
		$danger.position.y = -dangerHeight
		isRaising = false
		
