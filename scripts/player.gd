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
