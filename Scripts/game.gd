extends Node3D

#var time_left = 30
var player_score = 0

@onready var label = %Label
@onready var congrats: Label = %Congrats
@onready var time: Label = %Time
@onready var timer: Timer = %Timer


func _ready() -> void:
	timer.start()
	
func time_left_to_live():
	var time_left = timer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]

func _process(delta):
	time.text = '%02d:%02d' % time_left_to_live()

func increase_score():
	player_score += 1
	label.text = "Score: " + str(player_score)

func do_poof(mob_global_position):
	const SMOKE_PUFF = preload("res://Assets/mob/smoke_puff/smoke_puff.tscn")
	var poof = SMOKE_PUFF.instantiate()
	add_child(poof)
	poof.global_position = mob_global_position

func _on_mob_spawner_3d_mob_spawned(mob: Variant) -> void:
	mob.died.connect(func on_mob_died():
		increase_score()
		do_poof(mob.global_position)
		)
	do_poof(mob.global_position)


func _on_killzone_body_entered(body: Node3D) -> void:
	get_tree().reload_current_scene.call_deferred()
	

func _on_timer_timeout() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file('res://Scenes/end_menu.tscn')
	congrats.text = 'Congratulations! You won!!'
	

	
