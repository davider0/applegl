uniform lowp float estiramientoX;
uniform lowp float estiramientoZ;
uniform lowp float estiramientoY;
uniform lowp float estiramientoW;
uniform lowp float fSaturacion;
uniform lowp float fTamanyo;
uniform lowp float fGrosor;
uniform lowp float fLongitudDegradado;
uniform lowp float fCorteSeccion;
uniform lowp float fIntensidadTensor;
uniform lowp float fConcavidadTensor;
uniform lowp float fElevacionZEfectoDeformacion;
const lowp float fSuavidadEfectoDegradado = 7.0;
uniform lowp float fBrilloEfectoDegradado;
uniform lowp float fFondo;
uniform lowp float fSuavidadLineasEfectoDegradado;
uniform lowp float fColorR1;
uniform lowp float fColorG1;
uniform lowp float fColorB1;
uniform lowp float iColorR2;
uniform lowp float iColorG2;
uniform lowp float iColorB2;
uniform lowp float fPosicion;

/////////////////////////////////////////////////////////
// ether

//The current foreground texture co-ordinate
varying mediump vec2 vTex;
//The foreground texture sampler, to be sampled at vTex
uniform lowp sampler2D samplerFront;
//The current foreground rectangle being rendered
uniform mediump vec2 srcStart;
uniform mediump vec2 srcEnd;
//The current foreground source rectangle being rendered
uniform mediump vec2 srcOriginStart;
uniform mediump vec2 srcOriginEnd;
//The current foreground source rectangle being rendered, in layout 
uniform mediump vec2 layoutStart;
uniform mediump vec2 layoutEnd;
//The background texture sampler used for background - blending effects
uniform lowp sampler2D samplerBack;
//The current background rectangle being rendered to, in texture co-ordinates, for background-blending effects
uniform mediump vec2 destStart;
uniform mediump vec2 destEnd;
//The time in seconds since the runtime started. This can be used for animated effects
uniform mediump float seconds;
//The size of a texel in the foreground texture in texture co-ordinates
uniform mediump vec2 pixelSize;
//The current layer scale as a factor (i.e. 1 is unscaled)
uniform mediump float layerScale;
//The current layer angle in radians.
uniform mediump float layerAngle;

#define m *= mat2(cos(vec4(estiramientoX,estiramientoY,estiramientoZ,estiramientoW) + t*
#define M \
    (s.xz m.4)), s.xy m.3)), \
    length(s + sin(t*fGrosor))*log(length(s)+fTamanyo)+ \
    sin(sin(sin(s=s+s+t).y+s).z+s).x*fIntensidadTensor-fConcavidadTensor)

void main(void) {
    lowp vec3 p, s, O, R = vec3(1.0,pixelSize);
    lowp vec2 u = vec2(gl_FragCoord / R.y);
    lowp float t = seconds, d = fElevacionZEfectoDeformacion, r;
    
    for (lowp float i = 0.0; i < fSuavidadEfectoDegradado; i++) {
        t = seconds + i; // Update time within the loop
        s = p = vec3((u - fPosicion * R.xy) / R.y * d, fCorteSeccion - d);
        d += min(r = M, fSuavidadLineasEfectoDegradado); // Assuming M is defined elsewhere
        s = p + fSaturacion;
        lowp vec3 color = max(O + fBrilloEfectoDegradado - r * fLongitudDegradado, O + fFondo) * (vec3(fColorR1, fColorG1, fColorB1) - vec3(iColorR2, iColorG2, iColorB2) * (M - r) / 4.0);
        gl_FragColor = vec4(color, 1.0); // Set alpha to 1.0 for full opacity
    }
}