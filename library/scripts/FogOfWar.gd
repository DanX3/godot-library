extends Sprite2D

@export var fog_width := 1000
@export var fog_height := 500
@export var sight := 100.0
@export var grid_step := 64
@export var lightMask: Texture2D
var fogImage: Image
var fogTexture : ImageTexture
var lightImage : Image
var fog_size := Vector2(fog_width, fog_height)


# Called when the node enters the scene tree for the first time.
func _ready():
	lightImage = lightMask.get_image()
	lightImage.resize(sight, sight, Image.INTERPOLATE_BILINEAR)
	
	fogImage = Image.create(fog_width, fog_height, false, Image.FORMAT_RGBA8)
	fogImage.fill(Color(0, 0, 0, 0.9))
	texture = ImageTexture.create_from_image(fogImage)
	queue_redraw()

func update_fog(world_coords: Vector2):
	var coords = (world_coords - global_position) - 0.5 * lightImage.get_size()
	var c = coords
	coords = (coords / grid_step).floor() * grid_step
	print("%s -> %s " % [c, coords])
#	fogImage.blend_rect_mask(blackImage, lightMask.get_image(), lightImage.get_used_rect(), coords)
#	fogImage.blend_rect(lightImage, lightImage.get_used_rect(), coords)
	fogImage.blend_rect(lightImage, lightImage.get_used_rect(), coords)
	texture = ImageTexture.create_from_image(fogImage)

func _process(delta):
	if Engine.is_editor_hint():
		queue_redraw()

func _draw():
	draw_rect(Rect2(Vector2.ZERO, fog_size), Color.AQUA)
