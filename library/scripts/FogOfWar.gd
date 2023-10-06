extends Sprite2D

@export var fog_width := 1000
@export var fog_height := 500
@export var sight := 100.0
@export var grid_step := 64
@export var lightMask: Texture2D

var fogImage: Image
var lightImage : Image
var last_world_location := Vector2.ZERO

func _ready():
	lightImage = lightMask.get_image()
	lightImage.resize(sight, sight, Image.INTERPOLATE_BILINEAR)
	
	fogImage = Image.create(fog_width, fog_height, false, Image.FORMAT_RGBA8)
	fogImage.fill(Color(0, 0, 0, 0.9))
	texture = ImageTexture.create_from_image(fogImage)
	var fogScale = material.get_shader_parameter("fogScale")
	fogScale = fogScale * min(fog_width, fog_height) / 128.0
	print(fogScale)
	material.set_shader_parameter("fogScale", fogScale)

func update_fog(world_coords: Vector2):
	var coords = (world_coords - global_position) - 0.5 * lightImage.get_size()
	coords = (coords / grid_step).floor() * grid_step  + Vector2(0.5, 0.5) * grid_step;
	if coords == last_world_location:
		return
	print("cleared fog")
	last_world_location = coords
	fogImage.blend_rect(lightImage, lightImage.get_used_rect(), coords)
	texture = ImageTexture.create_from_image(fogImage)
