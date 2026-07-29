extends CharacterBody2D

@export var speed: float = 72
var screen_size = Vector2.ZERO
var is_flipped = false

var can_roll: bool = false
const ROLL_SPEED: float = 210
const ROLL_TIME: float = .2
var roll_timer: float = 0.0
const ROLL_RELOAD_COST: float = 0.5
var roll_reload_timer: float = 0.0

var rotateSpeed = deg_to_rad(360)/.3

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	
	var direction = Vector2.ZERO
	if roll_timer == 0.0:
		#region Inputs
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
			is_flipped = true
		if Input.is_action_pressed("move_right"):
			direction.x += 1
			is_flipped = false
		if Input.is_action_pressed("move_up"):
			direction.y -= 1
		if Input.is_action_pressed("move_down"):
			direction.y += 1
		#endregion
		#region Movement Response
		if direction != Vector2.ZERO:
			direction = direction.normalized()
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.play("idle")
		$AnimatedSprite2D.flip_h = is_flipped
		velocity = direction * speed
		#endregion
	_rollLogic(delta, direction)
	move_and_slide()
	
func _rollLogic(delta: float, direction: Vector2) -> void:
	var flip = 1;
	# Checked if flipped
	if(is_flipped):
		flip = -1
	# Check for input first
	if can_roll && Input.is_action_pressed("dodge"):
		# Flag for Roll
		can_roll = false
		roll_timer = ROLL_TIME
		roll_reload_timer = ROLL_RELOAD_COST
		velocity = (direction if direction.length() > 0 else Vector2.RIGHT * flip) * ROLL_SPEED
		$AnimatedSprite2D.play("roll")
	if roll_timer > 0.0:
		roll_timer = max(0.0, roll_timer - delta)
		# Check if flipped
		rotation += rotateSpeed * delta * flip
	else:
		rotation = 0
		if roll_reload_timer > 0.0:
			roll_reload_timer -= delta
		else:
			can_roll = true

func _setBounds(tiles: TileMapLayer) -> void:
	var rect = tiles.get_used_rect()
	$Camera2D.limit_left = rect.position.x * tiles.tile_set.tile_size.x
	$Camera2D.limit_right = rect.end.x * tiles.tile_set.tile_size.x
	$Camera2D.limit_top = rect.position.y * tiles.tile_set.tile_size.y
	$Camera2D.limit_bottom = rect.end.y * tiles.tile_set.tile_size.x
	
