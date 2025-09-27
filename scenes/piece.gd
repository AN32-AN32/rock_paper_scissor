extends Node2D

var velocity : Vector2
var speed: int = 100
var borderOff: int = 8
var type : int

var rock_tex = preload("res://rock.png")
var paper_tex = preload("res://paper.png")
var scissor_tex = preload("res://scissor.png")

var rocks : Node;
var papers : Node;
var scissors : Node;

func _ready() -> void:
	velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1))

func move(dt: float) -> void:
	position += velocity * speed * dt

func setup(rock_node: Node, paper_node: Node, scissor_node: Node):
	rocks = rock_node
	papers = paper_node
	scissors = scissor_node

func set_type(paramType: int) -> void:
	type = paramType
	if self.get_parent():
		get_parent().call_deferred('remove_child', self)
	match type:
		0:
			$Sprite2D.texture = rock_tex
			rocks.call_deferred('add_child', self)
		1:
			$Sprite2D.texture = paper_tex
			papers.call_deferred('add_child', self)
		2:
			$Sprite2D.texture = scissor_tex
			scissors.call_deferred('add_child', self)

func collision(border: Vector2i) -> void:
	if position.x <= borderOff || position.x >= border.x - borderOff:
		velocity.x *= -1
	if position.y <= borderOff || position.y >= border.y - borderOff:
		velocity.y *= -1

func _on_area_entered(area: Area2D) -> void:
	if type == 0 && area.type == 1:
		set_type(area.type)
	elif type == 1 && area.type == 0:
		area.set_type(type)
	elif type == 1 && area.type == 2:
		set_type(area.type)
	elif type == 2 && area.type == 1:
		area.set_type(type)
	elif type == 2 && area.type == 0:
		set_type(area.type)
	elif type == 0 && area.type == 2:
		area.set_type(type)
