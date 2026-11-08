extends Node2D

# logo
var frequency := 0.001
var amplitude := PI * 0.01

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$spiral.rotate(0.02) # spiral spins in bg
	# logo rocks back and forth
	$logo.rotation = sin(Time.get_ticks_msec() * frequency) * amplitude
