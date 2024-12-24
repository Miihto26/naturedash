extends Control

var score: int = 0
var combo_count: int = 0


func _ready():
	Signals.IncrementScore.connect(IncrementScore)
	Signals.IncrementCombo.connect(IncrementCombo)
	Signals.ResetCombo.connect(ResetCombo)
	
	ResetCombo()
	

func IncrementScore(incr: int):
	var combo_score_bonus = combo_count * 5
	if combo_score_bonus > 99:
		combo_score_bonus = 99 * 5
	score += incr + combo_score_bonus
	%ScoreLabel.text = " " + str(score)

func IncrementCombo():
	combo_count += 1
	%ComboLabel.text = " " + str(combo_count) + "x combo"
	
func ResetCombo():
	combo_count = 0
	%ComboLabel.text = " 0" + "x combo"
