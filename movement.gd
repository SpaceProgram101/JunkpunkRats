extends CharacterBody2D

@export var float_duration: float = 0.9
@export var float_gravity: float = 1000.0
@export var bullet_scene: PackedScene
@export var spread_angle: float = 90.0
@export var num_projectiles: int = 7
@export var fire_frame: int = 2

var floating: bool = false
var float_timer: float = 0.0
var is_shooting: bool = false

const SPEED = 300.0
const JUMP_VELOCITY = -700.0
var GRAVITY = 5000.0

func _ready():
	$AnimatedSprite2D.connect("frame_changed",Callable(self,"_on_frame_changed"))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	if not is_on_floor() and Input.is_action_just_pressed("up_spell"):
		trigger_cannon_attack()

	if floating:
		GRAVITY = float_gravity
		float_timer -= delta
		if float_timer <= 0:
			stop_floating()
			
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if not floating:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
	if floating:
		$AnimatedSprite2D.play("up_spell")
	elif not is_on_floor() and abs(velocity.y) > 0:
		$AnimatedSprite2D.play("fall")
	elif abs(velocity.x) > 0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")
	
		

	move_and_slide()
	
func trigger_cannon_attack():
	velocity.x = 0
	velocity.y = -500
	floating = true
	float_timer = float_duration
	is_shooting = false
	
	
	
func shoot_shotgun_blasts():
	
	var start_angle = -spread_angle / 2
	
	for i in range(num_projectiles):
		
		var angle_offset = start_angle + (i * (spread_angle / (num_projectiles -1)))
		var angle_rad = deg_to_rad(angle_offset)
		
		var bullet = bullet_scene.instantiate()
		
		if bullet is Area2D:
			
			var direction = Vector2(sin(angle_rad), -cos(angle_rad))
			bullet.direction = direction

			var bullet_position = position + Vector2(-25,-100)
			bullet.position = bullet_position
			
			var bullet_sprite = bullet.get_child(0)	
			var rotation_angle = direction.angle()
			bullet_sprite.rotation = rotation_angle
				
			get_parent().add_child(bullet)
			


func stop_floating():
	floating = false;
	GRAVITY = 2500


func _on_frame_changed():
	if is_shooting:
		return
	
	if $AnimatedSprite2D.frame == fire_frame:
		shoot_shotgun_blasts()
		is_shooting = true

		
