extends Node2D

# rhythm game signals
signal IncrementScore(incr: int)

signal IncrementCombo()
signal ResetCombo()

signal CreateFallingKey(button_name: String)
signal KeyListenerPress(button_name: String, array_num: int)


# game state signals
signal StartLevel(level_name: String)
signal FinishLevel(level_name: String)
