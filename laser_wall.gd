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
	laser_sfx.emitting = false
	laser_collider.disabled = true
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if can_laser:
		can_laser = false
		
		
		play("prep")
		await animation_finished
		play("firing")
		laser_sfx.emitting = true
		laser.visible = true
		laser_collider.disabled = false
		laser_sprite.play("default")
		await laser_sprite.animation_finished
		play("default")
		laser_sfx.emitting = false
		laser.visible = false
		laser_collider.disabled = true
		timer.start()
	


func _on_cooldown_timer_timeout() -> void:
	can_laser = true
