extends Node2D

const PAD_SPEED = 700
const INITIAL_BALL_SPEED = 500
const MAX_SCORE = 10

var screenSize
var batSize
var ballSize
var direction = Vector2(1.0, 0.0)
var ballSpeed = INITIAL_BALL_SPEED

var leftScore = 0
var rightScore = 0

var gameoverMenu

#------------------------------------------------------------------------------------
func _ready():
	screenSize = get_viewport_rect().size
	var leftBatNode = get_node("LeftBat")
	batSize = leftBatNode.get_rect().size * leftBatNode.transform.get_scale()
	var ballNode = get_node("Ball")
	ballSize = ballNode.get_rect().size * ballNode.transform.get_scale()
	gameoverMenu = get_node("GameOverMenu")
	gameoverMenu.hide()

#------------------------------------------------------------------------------------
func _process(delta):
	processBallMovement(delta)
	processBatMovement(delta)
	processScore()

#------------------------------------------------------------------------------------
func resetBallState():
	get_node("Ball").position = screenSize / 2
	if (direction.x < 0):
		direction =  Vector2(1.0, 0.0)
	else:
		direction = Vector2(-1.0, 0.0)
	ballSpeed = INITIAL_BALL_SPEED
	
#------------------------------------------------------------------------------------
func processBallMovement(delta):
	var ballPos = get_node("Ball").position
	var leftBatPos = get_node("LeftBat").position
	var rightBatPos = get_node("RightBat").position
	var leftRect = Rect2(leftBatPos - batSize * 0.5, batSize)
	var rightRect = Rect2(rightBatPos - batSize * 0.5, batSize)
	var ballRect = Rect2(ballPos - ballSize * 0.5, ballSize)

	# 球碰到上下边界反弹
	ballPos += direction * ballSpeed * delta
	if ((ballPos.y < 0 and direction.y < 0) or (ballPos.y > screenSize.y and direction.y > 0)):
		direction.y = -direction.y
	
	# 球碰到球拍的反弹处理
	if ((leftRect.intersects(ballRect) and direction.x < 0) or (rightRect.intersects(ballRect) and direction.x > 0)):
		var offset = 0
		if (leftRect.intersects(ballRect)): 
			if (Global.gameMode == Global.GAME_MODE_AUTO_PLAY):
				offset = 2.0 * randf() - 1.0
			else:
				offset = (ballPos.y - leftBatPos.y) / (batSize.y * 0.5)
		elif (rightRect.intersects(ballRect)): 
			if (Global.gameMode == Global.GAME_MODE_TWO_PLAYER):
				offset = (ballPos.y - rightBatPos.y) / (batSize.y * 0.5)
			else:
				offset = 2.0 * randf() - 1.0
				
		direction.x = -direction.x
		direction.y = offset
		direction = direction.normalized()
		if (ballSpeed < 2.0*INITIAL_BALL_SPEED): ballSpeed *= 1.05
	
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
func getMoveSpeedOfAI():
	var speed = PAD_SPEED
	if (Global.difficultyLevel == Global.DIFFICULTY_LEVEL_EASY): speed *= 0.4
	elif (Global.difficultyLevel == Global.DIFFICULTY_LEVEL_NORMAL): speed *= 0.55
	elif (Global.difficultyLevel == Global.DIFFICULTY_LEVEL_HARD): speed *= 0.7
	elif (Global.difficultyLevel == Global.DIFFICULTY_LEVEL_LEGEND): speed *= 0.85
	return speed
	
#------------------------------------------------------------------------------------
func moveLeftBatByAI(delta):
	var speed = getMoveSpeedOfAI()
	var ballPos = get_node("Ball").position
	var leftPos = get_node("LeftBat").position
	if (leftPos.y > batSize.y * 0.5 and ballPos.y < leftPos.y):
		leftPos.y += -speed * delta
	if (leftPos.y < screenSize.y - batSize.y * 0.5 and ballPos.y > leftPos.y):
	    leftPos.y += speed * delta
	get_node("LeftBat").position = leftPos
	
#------------------------------------------------------------------------------------
func moveRightBatByAI(delta):
	var speed = getMoveSpeedOfAI()
	var ballPos = get_node("Ball").position
	var rightPos = get_node("RightBat").position
	if (rightPos.y > batSize.y * 0.5 and ballPos.y < rightPos.y):
		rightPos.y += -speed * delta
	if (rightPos.y < screenSize.y - batSize.y * 0.5 and ballPos.y > rightPos.y):
	    rightPos.y += speed * delta
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
	
	if leftScore >= MAX_SCORE:
		get_tree().paused = true
		gameoverMenu.position.x = 250
		gameoverMenu.show()
	elif rightScore >= MAX_SCORE:
		get_tree().paused = true
		gameoverMenu.position.x = 550
		gameoverMenu.show()