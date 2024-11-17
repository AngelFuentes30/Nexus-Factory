extends CharacterBody2D

var speed: float = 600.0
var base_speed: float = 45.0  # Velocidad normal
var on_belt_count = 0  # Contador de cuántas cintas afectan al jugador
var animated_sprite: AnimatedSprite2D

func _ready():
	animated_sprite = $SpriteAnimated/AnimatedSprite2D
	animated_sprite.play("Walking_Down")

func on_belt_enter(cinta):
	on_belt_count += 1
	speed += cinta.move_speed * 0.5  # Aumenta la velocidad solo si está sobre una cinta

func on_belt_exit(cinta):
	on_belt_count = max(on_belt_count - 1, 0)
	if on_belt_count == 0:
		speed = base_speed  # Restablece la velocidad base cuando no hay cintas

func _physics_process(delta):
	var input_dir = Vector2()
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	if input_dir != Vector2.ZERO:
		velocity = input_dir.normalized() * speed

		# Cambia la animación según la dirección
		if input_dir.y > 0:
			animated_sprite.play("Walking_Down")
		elif input_dir.y < 0:
			animated_sprite.play("Walking_Up")
		elif input_dir.x > 0:
			animated_sprite.play("Walking_Right")
		elif input_dir.x < 0:
			animated_sprite.play("Walking_Left")
	else:
		velocity = Vector2.ZERO
		animated_sprite.stop()

	move_and_slide()
