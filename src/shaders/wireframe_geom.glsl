#version 150 core

layout(triangles) in;
layout(triangle_strip, max_vertices = 3) out;

noperspective out vec3 g_Dist;

void main() {
    float w = 800;
    float h = 600;
    mat4 ViewportMatrix = mat4(
        vec4(w/2, 0.0, 0.0, 0.0),
        vec4(0.0, h/2, 0.0, 0.0),
        vec4(0.0, 0.0, 0.5, 0.0),
        vec4(w/2, h/2, 0.5, 1.0)
    );

    // Transform each vertex.
    vec3 p0 = vec3(ViewportMatrix * (gl_in[0].gl_Position / gl_in[0].gl_Position.w));
    vec3 p1 = vec3(ViewportMatrix * (gl_in[1].gl_Position / gl_in[1].gl_Position.w));
    vec3 p2 = vec3(ViewportMatrix * (gl_in[2].gl_Position / gl_in[2].gl_Position.w));

    // Find the altitudes (ha, hb and hc).
    float a = length(p1 - p2);
    float b = length(p2 - p0);
    float c = length(p1 - p0);
    float alpha = acos( (b*b + c*c - a*a) / (2.0*b*c) );
    float beta = acos( (a*a + c*c - b*b) / (2.0*a*c) );
    float ha = abs( c * sin( beta ) );
    float hb = abs( c * sin( alpha ) );
    float hc = abs( b * sin( alpha ) );

    // Send the triangle along with the edge distances.
    g_Dist = vec3(ha, 0.0, 0.0);
    gl_Position = gl_in[0].gl_Position;
    EmitVertex();

    g_Dist = vec3(0.0, hb, 0.0);
    gl_Position = gl_in[1].gl_Position;
    EmitVertex();

    g_Dist = vec3(0.0, 0.0, hc);
    gl_Position = gl_in[2].gl_Position;
    EmitVertex();

    EndPrimitive();
}
