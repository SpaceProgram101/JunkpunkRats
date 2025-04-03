extends Area2D


@onready var player = get_node("/root/Node2D/Player")
@onready var music = get_node("/root/Node2D/AudioStreamPlayer")
@onready var body = get_node("/root/Node2D/final_laser/final_boss_collider")
@onready var main = $Node2D
@onready var emitter = $Node2D/AnimatedSprite2D
@onready var door = $bossdoor1
@onready var door_collider = $bossdoor1/CollisionShape2D
@onready var door2 = $bossdoor2
@onready var door_collider2 = $bossdoor2/CollisionShape2D
@onready var sparks = $CPUParticles2D
@onready var cooldown = $Timer
var can_laser = false
var firing = false
var active = false
var offset = PI / 8
var dead = false
var initial_pos = Vector2(0,0)
var initial_scale = Vector2(0,0)
var should_open_door = false

func _ready():
	sparks.emitting = false
	initial_pos = emitter.position
	initial_scale = emitter.scale
	door.visible = false
	door_collider.disabled = true
	door2.visible = false
	door_collider2.disabled = true
	body.immune = true

func _process(delta: float):
	if active and not dead:
		if can_laser and not firing:
			shoot_laser()
		elif not can_laser and firing:
			do_not_shoot_laser()
		if firing:
			var change = randf_range(-0.01, 0.01)
			emitter.scale += Vector2(change, change)
			emitter.position += Vector2(change, change)
		elif not firing:
			emitter.scale = initial_scale
			emitter.position = initial_pos
		main.rotation += offset * delta
	if should_open_door:
		body.immune = true
		door2.visible = false
		door_collider2.set_deferred("disabled", true)

func shoot_laser():
	sparks.emitting = true
	firing = true
	cooldown.start()


func do_not_shoot_laser():
	sparks.emitting = false
	firing = false
	cooldown.start()

		


func _on_timer_timeout() -> void:
	if firing:
		firing = false
		sparks.emitting = false
		can_laser = false
	elif not firing:
		firing = true
		can_laser = true


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not dead:
		should_open_door = false
		body.immune = false
		can_laser = true
		if not active:
			music.stream = music.final_boss_final
			music.play()
		active = true
		door.visible = true
		door_collider.set_deferred("disabled", false)
		door2.visible = true
		door_collider2.set_deferred("disabled", false)
	
