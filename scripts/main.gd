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


func _on_player_hit():
	$MobTimer.stop()
