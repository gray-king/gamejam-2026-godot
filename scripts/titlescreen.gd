extends Node2D

# logo
var frequency := 0.001
var amplitude := PI * 0.01

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$spiral.rotate(0.02) # spiral spins in bg
	# logo rocks back and forth
	$logo.rotation = sin(Time.get_ticks_msec() * frequency) * amplitude
