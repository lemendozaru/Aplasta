extends CharacterBody3D

# qué tan rápido se mueve el jugador en m/s
@export var speed = 14

# aceleración de caida en m/s2
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO

func _physics_process(delta: float):
	# creamos una variable local para almacenar la dirección de entrada
	var direction = Vector3.ZERO
	
	# checamos cada entrada y actualizamos la dirección acorde
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_forward"):
		# en 3D, el suelo se representa con el plano XZ
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# configurando la propiedad Basis que afecta la rotación
		$Pivot.basis = Basis.looking_at(direction)
		
	# vector velocidad en suelo
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# velocidad de caída
	if not is_on_floor(): # Si está en el aire, caerá hacia el suelo
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moviendo al jugador
	velocity = target_velocity
	move_and_slide()
