shader_type canvas_item;

uniform float speed=10.0;
uniform float brightness=1.5;


void fragment() {
	vec4 tex_color=texture(TEXTURE,UV);
	float time_color=sin(TIME*speed);
	vec3 rainbow=vec3(0.5+0.5*sin(TIME*speed),0.5+0.5*sin(TIME*speed+2.0),0.5+0.5*sin(TIME*speed+4.0));
	COLOR.rgb=tex_color.rgb*rainbow*brightness;
	COLOR.a=tex_color.a;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
