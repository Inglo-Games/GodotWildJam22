extends Camera2D

const zoom_limit_in : float = 1.0   # Min 1x zoom out
const zoom_limit_out : float = 8.0  # Max 8x zoom out
const zoom_step : float = 0.15
const move_step : float = 25.0

func _ready():
	pass

func _process(_delta):
	
	# Handle camera movement
	if Input.is_action_pressed("ui_left"):
		offset.x -= move_step
	if Input.is_action_pressed("ui_right"):
		offset.x += move_step
	if Input.is_action_pressed("ui_up"):
		offset.y -= move_step
	if Input.is_action_pressed("ui_down"):
		offset.y += move_step
	
	# Handle camera zoom
	if Input.is_action_pressed("cam_zoom_in"):
		if zoom.x > zoom_limit_in: zoom -= Vector2.ONE * zoom_step
	if Input.is_action_pressed("cam_zoom_out"):
		if zoom.x < zoom_limit_out: zoom += Vector2.ONE * zoom_step
