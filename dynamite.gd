extends CharacterBody2D

@onready var player = get_node("/root/Node2D/Player")
@onready var collider = get_node("/root/Node2D/Player/Area2D")
@onready var spawner = get_node("/root/Node2D/helicopter_boss")
@onready var sprite = $dynamite_sprite
@onready var explosion = $explosion_sprite
@onready var collision = $CollisionShape2D
var fuse = 3
var exploding = false
@onready var timer = $Timer
var in_radius = false
var target = CharacterBody2D
var on_ground = false
var start_position = Vector2(0,0)
var not_on_floor = true
var damage = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = "3"
	$Label.visible = true
	sprite.visible = true 
	exploding = false
	global_position = spawner.global_position
	start_position = global_position
	sprite.play("default")
	explosion.play("telegraph")
	timer.wait_time = 1
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_on_floor():
		
		velocity.x = 0
		velocity.y = 0
	if not is_on_floor():
		velocity.y += 880.0 * delta
	move_and_slide()

func explode():
	exploding = true
	sprite.visible = false
	explosion.play("explosion")
	collider.exploding = true
	await explosion.animation_finished
	collider.exploding = false
	queue_free()


func _on_timer_timeout() -> void:
	fuse -= 1
	if fuse == 3:
		$Label.text = "3"
	elif fuse == 2:
		$Label.text = "2"
	elif fuse == 1:
		$Label.text = "1"
	if fuse <= 0:
		timer.stop()
		$Label.visible = false
		explode()




func _on_explosion_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		collider.in_radius = true


func _on_explosion_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):	
		collider.in_radius = false
