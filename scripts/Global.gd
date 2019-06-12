extends Node

const GAME_MODE_ONE_PLAYER = 0
const GAME_MODE_TWO_PLAYER = 1
const GAME_MODE_AUTO_PLAY  = 2

const DIFFICULTY_LEVEL_EASY = 0
const DIFFICULTY_LEVEL_NORMAL = 1
const DIFFICULTY_LEVEL_HARD = 2
const DIFFICULTY_LEVEL_LEGEND = 3

const BORDER_MARGIN = Vector2(30, 50)

var gameMode = -1
var difficultyLevel =  -1