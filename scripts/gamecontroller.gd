extends Node

@onready var machineText = $UI/machinePartCounter

var objectsToFind = 5

func decreaseObjectCount():
	objectsToFind -= 1
	machineText.text = str(objectsToFind) + " left to find"
	if objectsToFind == 0:
		machineText.text = "YOU WIN!"
