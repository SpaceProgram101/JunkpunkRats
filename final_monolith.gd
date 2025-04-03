extends Area2D

var awake = false
var dead = false
var health = 20
@onready var death = preload("res://sound files/explosion-289984.mp3")
@onready var smoke = $CPUParticles2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 20
	smoke.emitting = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not dead:
		awake = get_parent().phase1
	elif dead:
		awake = false
	if awake:
		$AnimatedSprite2D.play("firing")
	
		
func take_damage(damage : int):
	if not dead:
		$AudioStreamPlayer2D.pitch_scale = randf_range(1, 1.5)
		$AudioStreamPlayer2D.play()
		health -= damage
		if health <= 0:
			health = 0
			die()
			
func die():
	$AudioStreamPlayer2D.stream = death
	$AudioStreamPlayer2D.play()
	dead = true
	awake = false
	smoke.emitting = true
	get_parent().rocketcount -= 1
	$laser_detector.queue_free()
	$AnimatedSprite2D.play("fucking dead")
