uniform sampler2D tex0;

void main(void)
{
	vec4 texPixel = texture2D(tex0, gl_TexCoord[0].xy);

	gl_FragColor = texPixel;
}
