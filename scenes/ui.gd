extends CanvasLayer

@onready var rock_label : Node = $BottomPanel/StatsContainer/RockPanel/Rocks
@onready var paper_label : Node = $BottomPanel/StatsContainer/PaperPanel/Papers
@onready var scissor_label : Node = $BottomPanel/StatsContainer/ScissorPanel/Scissors
@onready var type_button: Node = $BottomPanel/AddContainer/TypeButton

func set_count(rock_count: int, paper_count: int, scissor_count: int) -> void:
	rock_label.text = ": " + str(rock_count)
	paper_label.text = ": " + str(paper_count)
	scissor_label.text = ": " + str(scissor_count)

func on_game_over(text: String) -> void:
	$GameOver/PanelContainer/MarginContainer/VBoxContainer/Label.text = text
	$GameOver.show()
	$BottomPanel.hide()

func _on_pause_button_pressed() -> void:
	$"../manager".set_pause(true)

func _on_play_button_pressed() -> void:
	$"../manager".set_pause(false)

func _on_type_button_pressed() -> void:
	type_button.texture_normal = $"../manager".change_mouse_type()

func _on_restart_button_pressed() -> void:
	$"../manager".start()
	$GameOver.hide()
	$BottomPanel.show()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_start_button_pressed() -> void:
	$"../manager".start()
	$StartScreen.hide()
	$BottomPanel.show()
