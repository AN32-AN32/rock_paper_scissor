extends Node

@onready var piece : PackedScene = preload("res://scenes/piece.tscn")
@onready var window_size : Vector2i = get_window().size
@onready var gen_offset : int = 16
@onready var gen_size : Vector2i = window_size - Vector2i(gen_offset, gen_offset)

@onready var rocks : Node = $"../rocks"
@onready var papers : Node = $"../papers"
@onready var scissors : Node = $"../scissors"

const PIECE_COUNT : int = 10
var gameOver : bool = false

func generate(node : Node, type : int) -> void:
	for i in range(PIECE_COUNT):
		var new_piece = piece.instantiate()
		new_piece.setup(rocks, papers, scissors)
		new_piece.set_type(type)
		new_piece.position = Vector2(randi_range(gen_offset, gen_size.x), randi_range(gen_offset, gen_size.y))

func _ready() -> void:
	generate(rocks, 0)
	generate(papers, 1)
	generate(scissors, 2)

func _process(delta: float) -> void:
	if rocks.get_child_count() == PIECE_COUNT * 3:
		print("Rocks Win!")
		gameOver = true
	if papers.get_child_count() == PIECE_COUNT * 3:
		print("Paper Win!")
		gameOver = true
	if scissors.get_child_count() == PIECE_COUNT * 3:
		print("Scissor Win!")
		gameOver = true
	
	if !gameOver:
		for piece in rocks.get_children() + papers.get_children() + scissors.get_children():
			piece.move(delta)
			piece.collision(window_size)
