extends CharacterBody3D

# Emitida cuando el jugador es golpeado por el enemigo
signal hit

# qué tan rápido se mueve el jugador en m/s
@export var speed = 14
# aceleración de caida en m/s2
@export var fall_acceleration = 75
# Impulso vertical aplicado al caracter tras saltar (m/s)
@export var jump_impulse = 20
# Impulso vertical aplicado al caracter tras aplastar un enemigo (m/s)
@export var bounce_impulse = 16

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
		# hace más rápidas las animaciones
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1
	
	# arquearse al saltar
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse
		
	# vector velocidad en suelo
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# velocidad de caída
	if not is_on_floor(): # Si está en el aire, caerá hacia el suelo
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moviendo al jugador
	velocity = target_velocity
	
	# Saltar solo si el jugador está en el suelo y se presiona "jump"
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
		
	# Iterar a través de todas las colisiones por frame
	for index in range(get_slide_collision_count()):
		# Tomamos una de las colisiones con el caracter
		var collision = get_slide_collision(index)

		# Si hay colisiones duplicadas con un enemigo en un frame único
		# el enemigo será borrado después de la primera y una segunda llamada
		# a get_collider retornará null, llevando a un apuntador nulo al llamar
		# collision.get_collider().is_in_group("mob")

		# Este bloque previene el procesar colisiones duplicadas
		if collision.get_collider() == null:
			continue

		# Si el collider es con un enemigo
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# verficaremos que lo hemos golpeado desde arriba
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				# Si fue así, lo aplastaremos y rebotaremos
				mob.squash()
				target_velocity.y = bounce_impulse
				# Prevenimos posteriores llamadas duplicadas
				break
		
	# Moviendo al caracter
	velocity = target_velocity
	move_and_slide()

func die():
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(body: Node3D):
	die()
