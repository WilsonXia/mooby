extends CharacterBody2D

@export var speed = 50
var screen_size = Vector2.ZERO
var is_flipped = false

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	var direction = Vector2.ZERO
	
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
		
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")
		
	$AnimatedSprite2D.flip_h = is_flipped
	
	velocity = direction * speed
	move_and_slide()

func _setBounds(tiles: TileMapLayer) -> void:
	var rect = tiles.get_used_rect()
	print(rect)
	$Camera2D.limit_left = rect.position.x * tiles.tile_set.tile_size.x
	$Camera2D.limit_right = rect.end.x * tiles.tile_set.tile_size.x
	$Camera2D.limit_top = rect.position.y * tiles.tile_set.tile_size.y
	$Camera2D.limit_bottom = rect.end.y * tiles.tile_set.tile_size.x
	
