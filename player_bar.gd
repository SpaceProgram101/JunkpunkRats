extends ProgressBar

@onready var timer = $Timer
@onready var damage_bar = $DamageBar
@onready var dash_bar = $ProgressBar
@onready var player = get_node("/root/Node2D/Player")
var reduce = false
var health_reduce = false
var dash_reduce = false
var dash : float = 50
var health : float = 100 : set = _set_health
var lerp_speed: float = 2.0

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	health_reduce = true
	reduce = false
	if health < 0:
		queue_free()
		
	if health < prev_health:
		timer.start()
		
		
func _process (delta : float) -> void:
	var target = health
	if health_reduce:	
		value = lerp(value, target, get_process_delta_time() * lerp_speed * 2)
	if player.is_dashing:
		dash_bar.value = lerp(dash_bar.value, 0.0, get_process_delta_time() * lerp_speed * 2)
	elif not player.can_dash and not player.is_dashing:
		dash_bar.value = 100 - (100.0 * (player.cooldown_timer / player.dash_cooldown))
		print (dash_bar.value)
	if player.can_dash:
		dash_bar.value = 100
	if reduce:
		damage_bar.value = lerp(damage_bar.value, target, get_process_delta_time() * lerp_speed)	
	if damage_bar.value <= target:
		reduce = false
	if value <= target:
		health_reduce = false
	
	

func init_health(_health):
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	reduce = true
