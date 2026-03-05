extends Node

@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mob_timer_timeout() -> void:
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
