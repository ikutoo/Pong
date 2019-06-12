extends Sprite

var viewportSize

func _ready():
	viewportSize = get_viewport_rect().size
	
func _draw():
	var x = Global.BORDER_MARGIN.x
	var y = Global.BORDER_MARGIN.y
	draw_rect(Rect2(x, y, viewportSize.x - 2*x, viewportSize.y - 2*y), Color.white, false)