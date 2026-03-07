extends Node

@export var mob_scene: PackedScene

func _on_mob_timer_timeout():
	# creamos una nueva instancia de la escena Mob
	var mob = mob_scene.instantiate()

	# Elegimos un lugar aleatorio dentro de SpawnPath
	# Almacenamos la referencia de SpawnLocation
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# y le damos un espaciado aleatorio
	mob_spawn_location.progress_ratio = randf()

	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)

	# aparecemos al mob por agregarlo a la escena principal
	add_child(mob)
	
	# Conectamos el mob a la etiqueta de puntaje para actualizarla
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())

func _ready():
	$UserInterface/Retry.hide()

func _on_player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# esto reinicia la escena actual
		get_tree().reload_current_scene()
