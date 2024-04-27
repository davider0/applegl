
uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform float     iTime;                 // shader playback time (in seconds)
uniform float     iTimeDelta;            // render time (in seconds)
uniform float     iFrameRate;            // shader frame rate
uniform int       iFrame;                // shader playback frame
uniform float     iChannelTime[4];       // channel playback time (in seconds)
uniform vec3      iChannelResolution[4]; // channel resolution (in pixels)
uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
uniform samplerXX iChannel0..3;          // input channel. XX = 2D/Cube
uniform vec4      iDate;                 // (year, month, day, time in seconds)
uniform float     iSampleRate;           // sound sample rate (i.e., 44100)

#define PI 3.14159265359
#define ScaleWidth 0.04
#define ClockSize 0.7

#define HoursScaleWidth 0.015
#define MinutesScaleWidth 0.004

#define HourHandColor vec3(1.0)
#define HourHandCoreSize 0.025
#define HourHandLength1 0.1
#define HourHandWidth1 0.005
#define HourHandLength2 0.25
#define HourHandWidth2 0.02

#define MinuteHandColor vec3(1.0)
#define MinuteHandCoreSize 0.025
#define MinuteHandLength1 0.1
#define MinuteHandWidth1 0.005
#define MinuteHandLength2 0.5
#define MinuteHandWidth2 0.02

#define SecondHandColor vec3(0.961, 0.633, 0.332)
#define SecondHandCoreSize 0.02
#define SecondHandLength 0.7
#define SecondHandWidth 0.0035

#define PixelWidth 1.0/iResolution.y

vec3 line(vec2 coord, vec2 p1, vec2 p2, float width, vec3 color)
{
    vec2 v1 = coord - p1;
    vec2 v2 = p2 - p1;
    float j1 = dot(v1, v2);
    
    vec2 v3 = coord - p2;
    vec2 v4 = p1 - p2;
    float j2 = dot(v3, v4);
    
    float len;
    if( j1 > 0.0 && j2 > 0.0)
    {
        vec2 nv2 = normalize(v2);
        len = length(v1 - dot(v1, nv2) * nv2);
    }
    else
    {
        len = min(length(v1),length(v3));
    }
    return color * smoothstep(width + 2.0*PixelWidth, width, len);
}

vec3 clockScale(vec2 coord)
{
    vec3 color;
    
    //
    float l = length(coord);
    float onRing = step(ClockSize-ScaleWidth, l) - step(ClockSize, l);
    
    //
    float angle = atan(coord.y/coord.x);
    float d1 = mod(angle, PI/6.0);
    float d2 = d1 - PI/6.0;
    float onHoursScale = step(-HoursScaleWidth,d1) - step(HoursScaleWidth,d1);
    onHoursScale += step(-HoursScaleWidth,d2) - step(HoursScaleWidth,d2);
    
    // 
    float d3 = mod(angle, PI/30.0);
    float d4 = d3 - PI/30.0;
    float onMinutesScale = step(-MinutesScaleWidth,d3) - smoothstep(MinutesScaleWidth,MinutesScaleWidth+0.003,d3);
    onMinutesScale += smoothstep(-MinutesScaleWidth-0.003, -MinutesScaleWidth,d4) - step(MinutesScaleWidth,d4);
    
    color += vec3(1.0) * onRing * onHoursScale;
    color += vec3(0.6) * onRing * onMinutesScale;
    return color;
}

vec3 hourHand(vec2 coord)
{
    vec3 color;
    color += HourHandColor * smoothstep(HourHandCoreSize + PixelWidth, HourHandCoreSize, length(coord));
    
    float angle = 2.0 * PI * (iDate.w / 43200.0);
    vec2 direction = vec2(sin(angle), cos(angle));
    vec2 p1 = vec2(0.0);
    vec2 p2 = direction * HourHandLength1;
    color = max(color, line(coord, p1, p2, HourHandWidth1, HourHandColor));
    p1 = direction * HourHandLength1;
    p2 = p1 + direction * HourHandLength2;
    color = max(color, line(coord, p1, p2, HourHandWidth2, HourHandColor));
    
    return color;
}

vec3 minuteHand(vec2 coord)
{
    vec3 color;
    color += MinuteHandColor * smoothstep(MinuteHandCoreSize + PixelWidth, MinuteHandCoreSize, length(coord));
    
    float angle = 2.0 * PI * mod(iDate.w / 60.0, 60.0) / 60.0;
    vec2 direction = vec2(sin(angle), cos(angle));
    vec2 p1 = vec2(0.0);
    vec2 p2 = direction * MinuteHandLength1;
    color = max(color, line(coord, p1, p2, MinuteHandWidth1, MinuteHandColor));
    p1 = direction * MinuteHandLength1;
    p2 = p1 + direction * MinuteHandLength2;
    color = max(color, line(coord, p1, p2, MinuteHandWidth2, MinuteHandColor));
    
    return color;
}

vec3 secondHand(vec2 coord)
{
    vec3 color;
    color += SecondHandColor * smoothstep(SecondHandCoreSize + PixelWidth, SecondHandCoreSize, length(coord));
    
    float angle = 2.0 * PI * mod(iDate.w, 60.0) / 60.0;
    vec2 direction = vec2(sin(angle), cos(angle));
    vec2 p1 = direction * SecondHandLength;
    vec2 p2 = -direction * 0.15 * SecondHandLength;
    color = max(color, line(coord, p1, p2, SecondHandWidth, SecondHandColor));
    
    
    return color;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    vec2 coord = (2.0*fragCoord - iResolution.xy)/iResolution.y;
    
    vec3 color;
    vec3 temp;
    temp = clockScale(coord);
    color = step(1e-3, temp) * temp + step(length(temp), 1e-3) * color;
    
    temp = hourHand(coord);
    color = step(1e-3, temp) * temp + step(length(temp), 1e-3) * color;
    
    temp = minuteHand(coord);
    color = step(1e-3, temp) * temp + step(length(temp), 1e-3) * color;
    
    temp = secondHand(coord);
    color = step(1e-3, temp) * temp + step(length(temp), 1e-3) * color;

    float d = smoothstep(MinuteHandCoreSize*0.5 + PixelWidth, MinuteHandCoreSize*0.5, length(coord));
    color = vec3(0.0) * d + color * (1.0-d);
    fragColor = vec4(color,1.0);
}