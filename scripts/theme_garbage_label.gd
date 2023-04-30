extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update_text_size():
	var si = get_viewport_rect().size
	var scale_factor = min(si.x / 1920.0, si.y / 1080.0)
	add_theme_font_size_override("font_size", int(scale_factor * 32))
	
func _process(delta):
	update_text_size()
