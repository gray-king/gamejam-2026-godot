extends Area2D

@onready var gameManager = get_parent()
@onready var player = get_tree().get_first_node_in_group("player")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		gameManager.decreaseObjectCount()
		self.queue_free()
