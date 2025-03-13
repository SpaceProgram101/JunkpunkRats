extends ProgressBar

@onready var timer = $Timer
@onready var damage_bar = $DamageBar
var reduce = false
var lerp_speed: float = 2.0
var health : float = 100 : set = _set_health

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	reduce = false
	if health < 0:
		queue_free()
		
	if health < prev_health:
		timer.start()
		
func init_health(_health):
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var target = health
	if reduce:
		damage_bar.value = lerp(damage_bar.value, target, get_process_delta_time() * lerp_speed)		
	if damage_bar.value <= target:
		reduce = false

func _on_timer_timeout() -> void:
	reduce = true
