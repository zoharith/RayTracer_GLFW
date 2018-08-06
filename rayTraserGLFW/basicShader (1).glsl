 #version 130

uniform vec4 eye;
uniform vec4 ambient;
uniform vec4[20] objects;
uniform vec4[20] objColors;
uniform vec4[10] lightsDirection;
uniform vec4[10] lightsIntensity;
uniform vec4[10] lightPosition;
uniform ivec3 sizes; //number of objects & number of lights
 vec4 specular=vec4(0.7f,0.7f,0.7f,1.0f);
 float minvalue=-1;
  int minindex=-1;
  bool mirrorbool=false;
  int mirrorindex=-1;
  bool planebool=false;
  float diffusebla=1;
  vec3 point=vec3(0,0,0);
vec3 normal=vec3(0,0,0);




in vec3 position1;
vec3 getNormalSphere(vec4 sphere,vec3 point ){
  //vec3 p=p0+direction*t;
  vec3 center=sphere.xyz;
  return normalize(point-center);
}
float intersection(vec3 sourcePoint,vec3 v)
{

    return 0;

}

float intersection_plane (vec3  p0, vec3 direction,vec4 plane)
{
  vec3 normal=plane.xyz;
  float denom=dot(normal,direction.xyz);
  if(denom>0.001)
  {
    float mona=p0.x*plane.x+p0.y*plane.y+p0.z*plane.z+plane.w;
  float t=-mona/denom;
  if(t<0){
  return -1;
}
else return t;
}

return -1;
}




float intersection_sphere (vec3  p0, vec3 direction,vec4 sphere)
{
float x=0;
float a=dot(direction,direction);
vec3 center=sphere.xyz;
center=p0-center;
float b=2*dot(direction,center);
float c=dot(center,center)-sphere.w*sphere.w;

float delta=b*b-4*a*c;
if(delta<0.001)
  {
  return -1;
  }
  else
  {
    float x=(-b-sqrt(delta))/2*a;
    if(x<0.001){
      return (-b+sqrt(delta))/2*a;
    }
    return x;
  }

return -1; }


vec3  get_normal(vec4 object,vec3 point)
{
  if(object.w>0)
  return getNormalSphere(object,point);
  else return -normalize(object.xyz);

}


vec3 reflection_vec(vec3 normal,vec3 enter)
{
  return normalize(enter-2*normal*dot(enter,normal));
}

bool shdow_spot(int j, vec3 direction_light, vec3 point, float len){
    if(objects[j].w>0){
    float f=intersection_sphere(point, direction_light, objects[j]);
      if(f>0.01){
      float len1=length(f*direction_light);//to object
      if(len1<len){
        return false;
       }
      }
 }
 else{
  float f=intersection_plane(point, direction_light, objects[j]);
  if(f>0.01){
    float len1=length(f*direction_light);//to object
if(len1<len){
  return false;
}
  }
 }
 return true;
}


bool get_shadow(vec3 point,vec3 direction1,float minvalue,int j)
{
 float dist=-1;
 for(int i=0;i<sizes[0];i++){
  if (objects[i].w>0){
    dist=intersection_sphere(point, direction1, objects[i]);
  if(dist>0.0001){
    return true;
  }
  }
  else{
    dist=intersection_plane(point, direction1, objects[i]);
    if(dist>0.0001){
      return true;
    }
  }

 }
 return false;
}

float diffuseblack(vec3 j, int minindex){
  float x=j.x;
  float y=j.y;
    if(x*y<0){
    if(mod(int(1.5*x),2) == mod(int(1.5*y),2)){

   return 1;
  }
  else{
      return 0.5;
    }
  }
  else{
  if(mod(int(1.5*x),2) == mod(int(1.5*y),2)){
   return 0.5;
}
    else return 1;
}}


void calchit(vec3 intersectionPoint,vec3 direction1)
{

  for(int i=0;i<sizes[0];i++){
    if(objects[i].w>0){
      float f=intersection_sphere(intersectionPoint, direction1, objects[i]);
      if(f<0.01)
      {continue;}
      if(minvalue>=0 && f<minvalue && f>=0){
        minvalue=f;
        minindex=i;
      planebool=false;
      }
      else if(minvalue<0.01){
        minvalue=f;
        minindex=i;
        planebool=false;
      }
    }
    else
    {
    float planeinter=intersection_plane(intersectionPoint,direction1,objects[i]);
   if(planeinter<0.01)
      {continue;}
      if(minvalue>=0 && planeinter<minvalue && planeinter>=0){
        minvalue=planeinter;
        minindex=i;
      planebool=true;
      }
      else if(minvalue<0.01){
        minvalue=planeinter;
        minindex=i;
        planebool=true;
      }
    }
  }


}

vec3 planesq(vec3 j, int minindex){
  float x=j.x;
  float y=j.y;
    if(x*y<0){
    if(mod(int(1.5*x),2) == mod(int(1.5*y),2)){

   return objColors[minindex].xyz;
  }
  else{
      return objColors[minindex].xyz*0.5;
    }
  }
  else{
  if(mod(int(1.5*x),2) == mod(int(1.5*y),2)){
   return objColors[minindex].xyz*0.5;
}
    else return objColors[minindex].xyz;
}}






 vec3 getdiffuse(vec3 normal,int i,vec3 angle){
  vec3 l=normalize(-1*(angle.xyz));
        vec3 intensity=lightsIntensity[i].xyz;
return clamp(intensity*dot(normal,l),0.0f,1.0f);
}

vec3 getspecular(vec3 normal, vec3 direction1 , int i, int minindex, vec3 angle){
    vec3 r=reflection_vec(normal,angle.xyz);
      vec3 v=normalize(-1*direction1);
      float n=objColors[minindex].w;
      float maxvr=max(dot(v,r),0);
      return clamp(lightsIntensity[i].xyz*pow(maxvr,n),0.0f,1.0f);
}





vec3 calclighting(vec3 point,vec3 direction1,float minvalue,float diffusebla)
{
  //point point of objet intersect direction 1 ray direction minvalue=t of p=p0+vt
  vec3 color=vec3(0,0,0);
for(int i=0;i<sizes[1];i++)
    {
    if(lightsDirection[i].w==0){
    bool shadow=get_shadow(point,-lightsDirection[i].xyz,minvalue,i);
  if(shadow==false){
     color+=clamp(diffusebla*objColors[minindex].xyz*getdiffuse(normal,i,lightsDirection[i].xyz),0.0f,1.0f);
    color+=clamp(specular.xyz*getspecular(normal, direction1,i, minindex,lightsDirection[i].xyz),0.0f,1.0f);
      }
    }
      else{
      if(lightsDirection[i].w==1){
      vec3 angle=normalize(point-lightPosition[i].xyz);
      bool shadow=get_shadow(point,-angle,minvalue,i);
      if(shadow==false){
      vec3 l=normalize(lightsDirection[i].xyz);
      if(dot(angle,l)>lightPosition[i].w){
         color+=clamp(diffusebla*objColors[minindex].xyz*getdiffuse(normal,i,angle),0.0f,1.0f);
         color+=clamp(specular.xyz*getspecular(normal, direction1,i, minindex, angle),0.0f,1.0f);
        }
      }
      }
    }
  }
  return color;
}


vec3 colorCalc( vec3 intersectionPoint)
{
  vec3 color = vec3(0.0f,0.0f,0.0f);
  vec3 direction1=normalize(position1-intersectionPoint);
 
  calchit(intersectionPoint,direction1);

  if(minvalue<0){
      discard;
    }
    point=intersectionPoint+minvalue*direction1;
   if(planebool){
   color=vec3(0.1f,0.2f,0.3f)*planesq(point, minindex);
   diffusebla=diffuseblack(point,minindex);
  }

    normal=get_normal(objects[minindex],point);
    normal=normalize(normal);

    color+=calclighting(point,direction1,minvalue,diffusebla);
    
  if(!planebool){
     color+=vec3(0.1,0.2,0.3)*objColors[minindex].xyz;
  }
    color=clamp(color, 0.0f,1.0f);
    planebool=false;
    diffusebla=1;
      return color;
}

void main()
{

  vec4 c=vec4(colorCalc(eye.xyz),1.0f);

if(eye.w==2.0f)
  {mirrorbool=true;
    for(int j=0;j<sizes[0];j++)
    {
      if(objects[j].w<=0)
      {
        mirrorindex=j;
        break;
      }
    }
  }

if(mirrorbool&& minindex==mirrorindex){
  c=vec4(0,0,0,0);
   vec3 mirrornormal=normalize(-objects[mirrorindex].xyz);
   vec3 angle=normalize(point-eye.xyz);
   vec3 mirrordirection=normalize(reflection_vec(mirrornormal,angle));
     minindex=-1;
     minvalue=-1;
   calchit(point,mirrordirection);
     if(minvalue<0){
      discard;
    }
    vec3 tmp_point=point+minvalue*mirrordirection;
    if(minindex==1)
    normal=get_normal(objects[minindex],tmp_point);
      //c=vec4(0.1,0.2,0.3,1)*objColors[minindex];
      c+=vec4(clamp(calclighting(point,mirrordirection,minvalue,1),0,1),1);    
}
  gl_FragColor =c;
}
