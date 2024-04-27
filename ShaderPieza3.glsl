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

#define FMB 1
#define darkness .52
#if FMB == 1
#define dis .6
#else
#define dis 0.
#endif




float e(float a){return fract(iTime*a)*3.141593*4.;}
float g(float a,float b,float c){float d=clamp(.5+.5*(b-a)/c,0.,1.);
return mix(b,a,d)-c*d*(1.-d);}
mat2 j(float a){float b=sin(a),c=cos(a);
return mat2(c,b,-b,c);}
const mat2 J=mat2(-1.1,-.4,.3,1);
float K(in vec2 a){return sin(a.x)*sin(a.y);}
float r(vec2 b){float c=0.;for(float a=0.;a<5.;a++)c+=.15*K(b*a),b=J*b*abs(a-2.)*2.3;return c/1.;}
vec2 s(vec2 a){return vec2(r(a),r(a+vec2(7.8)));}
float t(vec3 c,int f){vec3 a=c;a.xz*=j(sin(e(.05))*.25),a.y+=.1;
float b=length(a)-.2;b=g(b,length(a+vec3(.13,.13,0))-.1,.08),b=g(b,length(a+vec3(-.13,.13,0))-.1,.08),b=g(b,length(a+vec3(-.13,-.04,0))-.1,.2),b=g(b,length(a+vec3(.13,-.04,0))-.1,.2),b=g(b,length(a+vec3(.17,-.19,0))-.12,.2),b=g(b,length(a+vec3(-.17,-.19,0))-.12,.2);float d=max(length(a.xy+vec2(.33,-.1))-.15,abs(a.z)-1.3);b=max(b,-d),a.x-=.25,a.y-=.08,a.xy*=j(.785398),b=min(b,max(length(a+vec3(.08,-.5,0))-.12,length(a+vec3(-.08,-.5,0))-.12)),b+=s(a.xz).y*dis*s(a.xy).x*1.*cos(a).y*1.*.6;return b;}float h(vec3 a){vec3 b=a;float c=t(b,1);return c;}
vec3 u(in vec3 b){vec2 a=vec2(1,-1)*.5773;return normalize(a.xyy*h(b+a.xyy*5e-4)+a.yyx*h(b+a.yyx*5e-4)+a.yxy*h(b+a.yxy*5e-4)+a.xxx*h(b+a.xxx*5e-4));}
vec3 m(vec2 a){vec2 b=a.xy-.5,c=b.xy*b.xy+sin(a.x*18.+e(.05))/25.*sin(a.y*7.+e(.05)*1.5)+a.x*sin(e(.05))/16.+a.y*sin(e(.05)*1.2)/16.;
float d=sqrt(abs(c.x+c.y*.5)*25.)*5.;return vec3(sin(d*1.25+2.),abs(sin(d*1.-1.)-sin(d)),abs(sin(d)*1.));}


void mainImage( out vec4 U, in vec2 V ){
	vec2 c=V.xy/iResolution.xy;c=(c-.5)*2.,c.x*=iResolution.x/iResolution.y;
	vec3 v=vec3(0,0,0),d=vec3(0,0,-.75),f=normalize(v-d),k=normalize(cross(f,vec3(0,1,0))),w=normalize(cross(k,f)),x=vec3(0),b=normalize(c.x*k+c.y*w+1.5*f);
	float i=0.;for(int y=0;y<32;++y){vec3 z=d+b*i;
	float L=h(z);i+=L*.99999;}vec3 l=vec3(0),n=normalize(vec3(.57703));
	n.xy*=j(fract(iTime*.135)*3.141593*2.);vec3 A=normalize(n-b),o=normalize(vec3(.57703));
	o.xy*=j(fract(iTime*.135)*3.141593*2.+3.141593);vec3 B=normalize(o-b),p=normalize(vec3(0,0,-.2));
	p.xz*=j(fract(iTime*.135)*3.141593*2.);vec3 C=normalize(p-b);if(i<5.){vec3 D=d+i*b,a=u(D);float E=clamp(dot(a,vec3(0,.5,.3)),0.,1.),F=clamp(dot(a,vec3(0,-.5,.3)),0.,1.),M=clamp(dot(a,vec3(0,.1,-.1)),0.,1.),G=pow(clamp(dot(a,A),darkness,1.),10.);G*=E+F;float H=pow(clamp(dot(a,B),darkness,1.),15.);H*=E+F;
	float I=pow(clamp(dot(a,C),darkness,1.),15.);
	I*=M;
	float N=dot(a,vec3(0,1,0));
	vec3 q=reflect(a*.03,b*.08);
	l=G*m(q.xy)+H*m(q.xy)+I*m(q.xy)*.8;}
	l=sqrt(l),x+=l,U=vec4(x,1);

}