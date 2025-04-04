extends ProgressBar

@onready var damage_bar = $damagebar
@onready var timer = $Timer
var reduce = false
var lerp_speed: float = 2.0
var health : float = 100 : set = _set_health
var should_shake = false

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health/5)
	value = health
	reduce = false
	timer.start()
	if health <= 0:
		should_shake = true
	
	
		
func init_health(_health):
	health = _health
	print("Check:", health)
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target = health
	if reduce:
		damage_bar.value = lerp(damage_bar.value, target, get_process_delta_time() * lerp_speed)		
	if damage_bar.value <= target:
		reduce = false
	if should_shake:
		position += Vector2(randf_range(-0.5,.5), randf_range(-0.5,0.5))


func _on_timer_timeout() -> void:
	reduce = true
