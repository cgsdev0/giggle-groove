extends ColorRect



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if (!visible && Signals.is_started) || visible:
			visible = !visible
			get_tree().paused = visible
