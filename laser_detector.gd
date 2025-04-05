extends Area2D

var awake = false
@onready var player = get_node("/root/Node2D/Player")
@onready var boss = get_parent()
var damage = 30
var rotation_offset = PI / 2
var rotation_speed = 0.25
var find_new = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	awake = boss.awake
	if awake:
		visible = true
		rotation += (PI / 12) * delta
