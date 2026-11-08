extends Node

@onready var machineText = $UI/machinePartCounter
@onready var hPtext = $UI/machinePartCounter/hpCounter

@onready var player = $Player
@onready var stompSFX = $stompSFX
@onready var squeakSFX = $squeakSFX
@onready var meowSFX = $meowSFX

var gameCompleted : bool = false

var objectsToFind = 5

func _ready() -> void:
	machineText.text = str(objectsToFind) + " left to find"

func _process(delta: float) -> void:
	hPtext.text = "HP: " + str(player.hp)
	if gameCompleted:
		get_tree().change_scene_to_file("res://scenes/levels/win.tscn")
	if player.hp <= 0:
		get_tree().change_scene_to_file("res://scenes/levels/game-over.tscn")

func decreaseObjectCount():
	objectsToFind -= 1
	machineText.text = str(objectsToFind) + " left to find"
	if objectsToFind == 0:
		machineText.text = "Return to your time machine!"
		
