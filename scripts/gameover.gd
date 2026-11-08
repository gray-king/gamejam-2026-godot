extends Node

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
