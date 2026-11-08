extends Node

@onready var machineText = $UI/machinePartCounter
@onready var hPtext = $UI/machinePartCounter/hpCounter

@onready var player = $Player

var objectsToFind = 5

func _process(delta: float) -> void:
	hPtext.text = "HP: " + str(player.hp)

func decreaseObjectCount():
	objectsToFind -= 1
	machineText.text = str(objectsToFind) + " left to find"
	if objectsToFind == 0:
		machineText.text = "Return to your time machine!"
