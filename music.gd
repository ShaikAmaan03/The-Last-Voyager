extends AudioStreamPlayer2D
func _ready() -> void:
	pass


func _on_timer_timeout() -> void:
	print("Now")
	$".".play()
	pass 
func _process(delta: float) -> void:
	pass


func _on_finished() -> void: # For some reason the Audio wasn't looping so I had to do this.
	$".".play()
	pass
