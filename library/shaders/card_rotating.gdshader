shader_type canvas_item;

uniform vec3 rotation = vec3(0.0);
uniform float focalLength;
uniform vec2 mouse_pos;

mat3 offset(vec2 offset) {
	return mat3(
		vec3(1, 0, offset.x),
		vec3(0, 1, offset.y),
		vec3(0, 0, 1)
	);
}

mat3 rotatorX(float angle) {
	float c = cos(angle);
	float s = sin(angle);
	return mat3(
		vec3(1, 0, 0),
		vec3(0, c, -s),
		vec3(0, s, c)
	);
}

mat3 rotatorY(float angle) {
	float c = cos(angle);
	float s = sin(angle);
	return mat3(
		vec3(c, 0, s),
		vec3(0, 1, 0),
		vec3(-s, 0, c)
	);
}

mat3 rotatorZ(float angle) {
	float c = cos(angle);
	float s = sin(angle);
	return mat3(
		vec3(c, -s, 0),
		vec3(s, c, 0),
		vec3(0, 0, 1)
	);
}



//void vertex() {
	//vec3 t = vec3(VERTEX.x, VERTEX.y, 0) * offset(vec2(-0.5))
		//* rotatorX(rotation.x)
		//* rotatorY(rotation.y)
		//* rotatorZ(rotation.z)
		//* offset(vec2(0.5));
	////t /= t.z;
	//VERTEX = t.xy;
//}

void vertex() {
	float depth = length(mouse_pos - VERTEX);
	VERTEX.y = VERTEX.y / (depth + focalLength);
}