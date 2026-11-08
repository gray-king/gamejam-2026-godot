extends Area2D

@onready var gameController = self.get_parent()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if gameController.objectsToFind == 0:
			gameController.gameCompleted = true
