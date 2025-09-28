extends Control

@onready var rock_label : Node = $BottomPanel/StatsContainer/RockPanel/Rocks
@onready var paper_label : Node = $BottomPanel/StatsContainer/PaperPanel/Papers
@onready var scissor_label : Node = $BottomPanel/StatsContainer/ScissorPanel/Scissors

func set_count(rock_count: int, paper_count: int, scissor_count: int) -> void:
	rock_label.text = str(rock_count)
	paper_label.text = str(paper_count)
	scissor_label.text = str(scissor_count)
