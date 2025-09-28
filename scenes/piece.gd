extends Node2D

var velocity : Vector2
var speed: int = 100
var borderOff: int = 8
var type : int

var manager: Node;

func _ready() -> void:
	velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1))

func move(dt: float) -> void:
	position += velocity * speed * dt

func setup(manager_node: Node):
	manager = manager_node

func set_texture(tex: Resource) -> void:
	$Sprite2D.texture = tex

func set_type(param: int) -> void:
	type = param

func collision(border: Vector2i) -> void:
	if position.x <= borderOff || position.x >= border.x - borderOff:
		velocity.x *= -1
	if position.y <= borderOff || position.y >= border.y - borderOff:
		velocity.y *= -1

func _on_area_entered(area: Area2D) -> void:
	if type == 0 && area.type == 1:
		manager.change_type(self, area.type)
	elif type == 1 && area.type == 0:
		manager.change_type(area, type)
	elif type == 1 && area.type == 2:
		manager.change_type(self, area.type)
	elif type == 2 && area.type == 1:
		manager.change_type(area, type)
	elif type == 2 && area.type == 0:
		manager.change_type(self, area.type)
	elif type == 0 && area.type == 2:
		manager.change_type(area, type)
