extends Sprite

var viewportSize

func _ready():
	viewportSize = get_viewport_rect().size

func _draw():
	var y_top = Global.BORDER_MARGIN.y
	var y_bottom = viewportSize.y - y_top
	draw_line(Vector2(viewportSize.x/2, y_top), Vector2(viewportSize.x/2, y_bottom), Color.white, 1.0, true);