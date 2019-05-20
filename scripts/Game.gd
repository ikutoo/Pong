extends Node2D

const PAD_SPEED = 700
const INITIAL_BALL_SPEED = 500

var screenSize
var batSize
var direction = Vector2(1.0, 0.0)
var ballSpeed = INITIAL_BALL_SPEED

var leftScore = 0
var rightScore = 0

#------------------------------------------------------------------------------------
func _ready():
	screenSize = get_viewport_rect().size
	var leftBatNode = get_node("LeftBat")
	batSize = leftBatNode.get_rect().size * leftBatNode.transform.get_scale()

#------------------------------------------------------------------------------------
func _process(delta):
	processBallMovement(delta)
	processBatMovement(delta)
	processScore()

#------------------------------------------------------------------------------------
func resetBallState():
	get_node("Ball").position = screenSize / 2
	direction =  Vector2(1.0, 0.0)
	
#------------------------------------------------------------------------------------
func processBallMovement(delta):
	var ballPos = get_node("Ball").position
	var leftRect = Rect2(get_node("LeftBat").position - batSize * 0.5, batSize)
	var rightRect = Rect2(get_node("RightBat").position - batSize * 0.5, batSize)

	# 球碰到上下边界反弹
	ballPos += direction * ballSpeed * delta
	if ((ballPos.y < 0 and direction.y < 0) or (ballPos.y > screenSize.y and direction.y > 0)):
		direction.y = -direction.y
	
	# 球碰到球拍的反弹处理
	if ((leftRect.has_point(ballPos) and direction.x < 0) or (rightRect.has_point(ballPos) and direction.x > 0)):
   		direction.x = -direction.x
    	direction.y = randf() * 2.0 - 1.0
    	direction = direction.normalized()
	
	get_node("Ball").position = ballPos
		
	# 球越出左右边界，计算得分
	if ballPos.x < 0:
		rightScore += 1
		resetBallState()
	elif ballPos.x > screenSize.x:
		leftScore += 1
		resetBallState()

#------------------------------------------------------------------------------------
func moveLeftBatByPlayer(delta):
	var leftPos = get_node("LeftBat").position
	if (leftPos.y > batSize.y * 0.5 and Input.is_action_pressed("left_move_up")):
		leftPos.y += -PAD_SPEED * delta
	if (leftPos.y < screenSize.y - batSize.y * 0.5 and Input.is_action_pressed("left_move_down")):
		leftPos.y += PAD_SPEED * delta
	get_node("LeftBat").position = leftPos

#------------------------------------------------------------------------------------
func moveRightBatByPlayer(delta):
	var rightPos = get_node("RightBat").position
	if (rightPos.y > batSize.y * 0.5 and Input.is_action_pressed("right_move_up")):
		rightPos.y += -PAD_SPEED * delta
	if (rightPos.y < screenSize.y - batSize.y * 0.5 and Input.is_action_pressed("right_move_down")):
	    rightPos.y += PAD_SPEED * delta
	get_node("RightBat").position = rightPos

#------------------------------------------------------------------------------------
func moveLeftBatByAI(delta):
	pass
	
#------------------------------------------------------------------------------------
func moveRightBatByAI(delta):
	if (Global.aiDecisionInterval > 0): 
		Global.aiDecisionInterval -= 1
		return
	else:
		Global.aiDecisionInterval = 2
		
	var ballPos = get_node("Ball").position
	var rightPos = get_node("RightBat").position
	if (rightPos.y > batSize.y * 0.5 and ballPos.y < rightPos.y):
		rightPos.y += -PAD_SPEED * delta
	if (rightPos.y < screenSize.y - batSize.y * 0.5 and ballPos.y > rightPos.y):
	    rightPos.y += PAD_SPEED * delta
	get_node("RightBat").position = rightPos

#------------------------------------------------------------------------------------
func processBatMovement(delta):
	if Global.gameMode == Global.GAME_MODE_ONE_PLAYER:
		moveLeftBatByPlayer(delta)
		moveRightBatByAI(delta)
	elif Global.gameMode == Global.GAME_MODE_TWO_PLAYER:
		moveLeftBatByPlayer(delta)
		moveRightBatByPlayer(delta)
	elif Global.gameMode == Global.GAME_MODE_AUTO_PLAY:
		moveLeftBatByAI(delta)
		moveRightBatByAI(delta)

#------------------------------------------------------------------------------------
func processScore():
	get_node("UI/LeftScore").text = String(leftScore)
	get_node("UI/RightScore").text = String(rightScore)
	
#	if leftScore >= 10:
#
#    ballSpeed = INITIAL_BALL_SPEED
#    direction = Vector2(-1, 0)