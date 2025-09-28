extends Node

@onready var piece_scene : PackedScene = preload("res://scenes/piece.tscn")
@onready var window_size : Vector2i = get_window().size
@onready var gen_offset : int = 16
@onready var gen_size : Vector2i = window_size - Vector2i(gen_offset, gen_offset)

var pieces_tex : Array[Resource] = [preload("res://rock.png"), preload("res://paper.png"), preload("res://scissor.png")]

@onready var rocks : Node = $"../rocks"
@onready var papers : Node = $"../papers"
@onready var scissors : Node = $"../scissors"
@onready var ui : Node = $"../UI"

const PIECE_COUNT : int = 10
var in_menu_scr : bool = false
var pause : bool = false
var mousePressed : bool = false
var selected_type : int = 0

@export var spawn_cooldown := 0.5 # seconds
var last_spawn_time := 0.0
var last_spawn_pos := Vector2.ZERO

func spawn(type: int, position: Vector2) -> void:
	var new_piece = piece_scene.instantiate()
	new_piece.setup(self)
	change_type(new_piece, type)
	new_piece.position = position

func generate(type : int) -> void:
	for i in range(PIECE_COUNT):
		spawn(type, Vector2(randi_range(gen_offset, gen_size.x), randi_range(gen_offset, gen_size.y)))

func set_pause(state: bool) -> void:
	pause = state

func change_mouse_type() -> Resource:
	selected_type = (selected_type + 1) % 3
	return pieces_tex[selected_type]

func change_type(node: Node, type: int):
	if in_menu_scr:
		return

	if node.get_parent():
		node.get_parent().call_deferred('remove_child', node)
	match type:
		0:
			rocks.call_deferred('add_child', node)
		1:
			papers.call_deferred('add_child', node)
		2:
			scissors.call_deferred('add_child', node)
	
	node.set_texture(pieces_tex[type])
	node.set_type(type)

func clear_n_fill_board() -> void:
	for child in rocks.get_children() + papers.get_children() + scissors.get_children():
		child.queue_free()
	in_menu_scr = false
	for i in range(0, 3): generate(i)
	in_menu_scr = true

func start() -> void:
	clear_n_fill_board()
	in_menu_scr = false

func _ready() -> void:
	for i in range(0, 3): generate(i)
	in_menu_scr = true

func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			mousePressed = true
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			mousePressed = false

func _process(delta: float) -> void:
	ui.set_count(rocks.get_child_count(), papers.get_child_count(), scissors.get_child_count())
	if !papers.get_child_count() && !scissors.get_child_count():
		ui.on_game_over("ROCK WINS!")
		clear_n_fill_board()
		in_menu_scr = true
	if !rocks.get_child_count() && !scissors.get_child_count():
		ui.on_game_over("PAPER WINS!")
		clear_n_fill_board()
		in_menu_scr = true
	if !papers.get_child_count() && !rocks.get_child_count():
		ui.on_game_over("SCISSOR WINS!")
		clear_n_fill_board()
		in_menu_scr = true
	
	if Input.is_action_just_pressed("ui_accept"):
		ui.on_game_over("SCISSOR WINS!")
		clear_n_fill_board()
		in_menu_scr = true
	
	if !pause:
		if mousePressed:
			var now = Time.get_ticks_msec() / 1000.0
			if (now - last_spawn_time > spawn_cooldown) || (get_viewport().get_mouse_position().distance_to(last_spawn_pos) > 5):
				spawn(
					selected_type,
					get_viewport().get_mouse_position()
				)
				last_spawn_time = now
				last_spawn_pos = get_viewport().get_mouse_position()
		for piece in rocks.get_children() + papers.get_children() + scissors.get_children():
			piece.move(delta)
			piece.collision(window_size)
