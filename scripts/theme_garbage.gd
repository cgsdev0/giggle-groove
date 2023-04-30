extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var initial_font_size = null
func update_text_size():
	if initial_font_size == null:
		initial_font_size = theme.default_font_size
	var si = get_viewport_rect().size
	var scale_factor = min(si.x / 1920.0, si.y / 1080.0)
	theme.default_font_size = int(initial_font_size * scale_factor)
	
func _process(delta):
	update_text_size()
