extends Sprite

var screenSize

func _ready():
	screenSize = get_viewport_rect().size

func _draw():
	draw_line(Vector2(screenSize.x/2, 0), Vector2(screenSize.x/2, screenSize.y), Color.white, 1.0, true);