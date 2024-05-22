precision mediump float;

uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform float     iTime;                 // shader playback time (in seconds)
uniform float     iTimeDelta;            // render time (in seconds)
uniform float     iFrameRate;            // shader frame rate
uniform int       iFrame;                // shader playback frame
uniform float     iChannelTime[4];       // channel playback time (in seconds)
uniform vec3      iChannelResolution[4]; // channel resolution (in pixels)
uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
uniform sampler2D iChannel0;             // input channel. XX = 2D/Cube
uniform sampler2D iChannel1;             // input channel. XX = 2D/Cube
uniform sampler2D iChannel2;             // input channel. XX = 2D/Cube
uniform sampler2D iChannel3;             // input channel. XX = 2D/Cube
uniform vec4      iDate;                 // (year, month, day, time in seconds)
uniform float     iSampleRate;           // sound sample rate (i.e., 44100)

// Movimiento
const float estiramientoX = 0.0;
const float estiramientoZ = 55.0;
const float estiramientoY = 33.0;
const float estiramientoW = 0.0;

// Tamaño
const float fSaturacion = 0.1;
const float fTamanyo = 1.0;
const float fGrosor = 0.7;
const float fLongitudDegradado = 0.29;
const float fCorteSeccion = 5.0;

// Huecos
const float fIntensidadTensor = 0.5;
const float fConcavidadTensor = 1.0;

// Detalles
const float fElevacionZEfectoDeformacion = 2.5;
const float fSuavidadEfectoDegradado = 7.0;
const float fBrilloEfectoDegradado = 0.9;
const float fFondo = 0.0;
const float fSuavidadLineasEfectoDegradado = 1.0;

// Colores
// Color 1
const float fColorR1 = 0.1;
const float fColorG1 = 0.3;
const float fColorB1 = 0.4;
// Color 2
const int iColorR2 = 10;
const int iColorG2 = 5;
const int iColorB2 = 6;

//Posicion
const float fPosicion = 0.5; // 0.5 es el centro de la pantalla

#define m *= mat2(cos(vec4(estiramientoX,estiramientoY,estiramientoZ,estiramientoW) + t*
#define M \
    (s.xz m.4)), s.xy m.3)), \
    length(s + sin(t*fGrosor))*log(length(s)+fTamanyo)+ \
    sin(sin(sin(s=s+s+t).y+s).z+s).x*fIntensidadTensor-fConcavidadTensor)

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec3 p, s, O, R = iResolution;
    vec2 u = fragCoord / R.y;
    float t = iTime, d = fElevacionZEfectoDeformacion, r;
    for (float i = 0.0; i < fSuavidadEfectoDegradado; i++) {
        t = iTime + i; // Update time within the loop
        s = p = vec3((u - fPosicion * R.xy) / R.y * d, fCorteSeccion - d);
        d += min(r = M, fSuavidadLineasEfectoDegradado); // Assuming M is defined elsewhere
        s = p + fSaturacion;
        vec3 color = max(O + fBrilloEfectoDegradado - r * fLongitudDegradado, O + fFondo) * (vec3(fColorR1, fColorG1, fColorB1) - vec3(iColorR2, iColorG2, iColorB2) * (M - r) / 4.0);
        fragColor = vec4(color, 1.0); // Set alpha to 1.0 for full opacity
    }
}