extends Area2D

var awake = false
var dead = false
var health = 20
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
		health -= damage
		if health <= 0:
			health = 0
			die()
			
func die():
	dead = true
	awake = false
	smoke.emitting = true
	get_parent().rocketcount -= 1
	$AnimatedSprite2D.play("fucking dead")
