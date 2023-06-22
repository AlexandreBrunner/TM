#include <AccelStepper.h>

AccelStepper stepper(2, 51, 50);

const int Fu = 20;
int Lcount = 1;
float V0, tc, t0, tend, Xend;
double Xt, X0;

float a = 4000.0;
float ac = 4000.0;

void setup() {
  //Serial.begin(9600);

  stepper.setMaxSpeed(4000);
  stepper.setAcceleration(13000000);

  delay(3000);
  
  t0 = millis()/1000.0;
}

void loop() {
  accel(a);
  a-=1;
}

void accel(float a){
  tc = millis()/1000.0;
  Xt = 0.5*ac*(tc-t0)*(tc-t0) + V0*(tc-t0) + X0;
  
  stepper.moveTo(Xt);
  stepper.run();

  if(Lcount % Fu == 0 && tend-tc != 0){
    X0 = Xt;
    V0 = (Xend-Xt)/(tend-tc);
    t0 = tc;
    ac = a;
  }
  
  Xend = Xt;
  tend = tc;
  Lcount++;
}
