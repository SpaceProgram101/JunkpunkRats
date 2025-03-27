extends AnimatedSprite2D

@onready var timer = $cooldown_timer
@onready var laser = $Area2D
@onready var laser_sprite = $Area2D/AnimatedSprite2D
@onready var laser_collider = $Area2D/CollisionShape2D
@onready var laser_light = $Area2D/PointLight2D
@onready var laser_sfx = $CPUParticles2D
var can_laser = false
var damage = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	laser.visible = false
	timer.start()
	laser_sfx.emitting = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_laser:
		play("prep")
		await animation_finished
		play("firing")
		laser_sfx.emitting = true
		can_laser = false
		laser.visible = true
		laser_sprite.play("default")
		await laser_sprite.animation_finished
		play("default")
		laser_sfx.emitting = false
		timer.start()
		laser.visible = false
	


func _on_cooldown_timer_timeout() -> void:
	can_laser = true
