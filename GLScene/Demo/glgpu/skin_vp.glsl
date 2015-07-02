uniform mat4 skinMatrices[90];

void main(void) {

	vec4 pos = vec4(0.0, 0.0, 0.0, 0.0);
		
	// firt 4 bones per vert
		
	//vec4 bones4 = gl_MultiTexCoord1;
		    
  pos += (skinMatrices[int(gl_MultiTexCoord1[0])] * gl_MultiTexCoord3) * gl_MultiTexCoord2[0];
  pos += (skinMatrices[int(gl_MultiTexCoord1[1])] * gl_MultiTexCoord4) * gl_MultiTexCoord2[1];
  pos += (skinMatrices[int(gl_MultiTexCoord1[2])] * gl_MultiTexCoord5) * gl_MultiTexCoord2[2];
  pos += (skinMatrices[int(gl_MultiTexCoord1[3])] * gl_MultiTexCoord6) * gl_MultiTexCoord2[3];
        
	//for(int i=0; i < 4; i++)
	//	pos += (skinMatrices[int(gl_MultiTexCoord1[i])] * gl_Vertex) * gl_MultiTexCoord2[i];
    
		// next 4 bones per vert
		
	/*	vec4 bones8 = gl_MultiTexCoord3;
		vec4 weight8 = gl_MultiTexCoord4;		
		
		for(int i=0; i < 4; i++)
		{
			int index = int(bones8[i]);
			float weight = weight8[i];

			pos += (skinMatrices[index] * gl_Vertex) * weight;
		}
	*/	

	gl_TexCoord[0] = gl_MultiTexCoord0;

	gl_Position = gl_ModelViewProjectionMatrix*pos;

}