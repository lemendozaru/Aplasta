extends CharacterBody3D

# velocidad mínima del enemigo en m/s
@export var min_speed = 10
# velocidad máxima del enemigo en m/s
@export var max_speed = 18


func _physics_process(_delta):
	move_and_slide()
	
func initialize(start_position, player_position):
	# Colocamos el enemigo en su posición inicial
	# y lo rotamos hacia el jugador
	look_at_from_position(start_position, player_position, Vector3.UP)
	# Rota al enemigo aleatoriamente en un rango de -45 a +45°
	# para no irse directamente hacia el jugador
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	# Calculamos una velocidad random
	var random_speed = randi_range(min_speed, max_speed)
	# Calculamos la velocidad del enemigo
	velocity = Vector3.FORWARD * random_speed
	# Rotamos el vector de velocidad de acuerdo al enemigo
	# para que se mueva hacia donde está girado
	velocity = velocity.rotated(Vector3.UP, rotation.y)


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
