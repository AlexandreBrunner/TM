#include <AccelStepper.h>

// Define a stepper and the pins it will use
AccelStepper stepper(2, 51, 50);

// Define a pin for the end switch
#define SwPin 40

//Define pins for the encoder HEDS 5504: Channel A, channel B, channel C
#define CHA 31
#define CHB 30
#define CHC 32

bool AState = LOW;
bool BState = LOW;
bool CState = LOW;

bool lastEnc = LOW;
int encCount = 0;
int encInit = 0;

//variables for to evaluate the system
#define deltaTc 0.01 
int theta, LastTheta;
float tc, LastTc, thetaDot, XDot;
int X, LastX;

//variables for PID
#define Kpp 100
#define Kdp 10

#define Kpc -0.001
#define Kdc -0.001

int targP = 0;
int er;
float V, deltaV;

void setup() {

  //initiate serial communication
  Serial.begin(230400);
  
  //Define Switch and encodeur as input
  pinMode(CHA, INPUT);
  pinMode(CHB, INPUT);
  pinMode(CHC, INPUT);

  pinMode(SwPin, INPUT);

  //initiate the stepper position
  InitStepper();

  delay(3000);  //wait for the pendulum to stabilize
  InitEnc();
  
  //initate the pendulum's angle  
      
  //set max speed and max acceleration for the stepper
  stepper.setMaxSpeed(4000);
  stepper.setAcceleration(13000000);
  
}

void loop() {

  tc = millis()/1000.0;
  theta = ReadEnc();
  X = stepper.currentPosition();

  stepper.setSpeed(V);
  stepper.runSpeed();
  
  if (tc - LastTc > deltaTc){
    systEval();
    feedback();
  }
  
}

void InitStepper(){
  stepper.setMaxSpeed(1200);
  stepper.setAcceleration(1000);

  stepper.move(-10000);
  
  while(digitalRead(SwPin)){
    stepper.run();
  }
  stepper.setCurrentPosition(-2700);
  stepper.moveTo(0);
  
  while(stepper.distanceToGo() > 0)
  stepper.run(); 
}

int ReadEnc(){
  AState = digitalRead(CHA);
  BState = digitalRead(CHB);
  CState = digitalRead(CHC);
  
  if (lastEnc != AState){
    if(AState == BState){
        encCount++;
      }else{
        encCount--;
      }
      lastEnc = AState; 
      
      if(CState){
      encCount = encInit;

    }
  }
  return encCount;
}

void InitEnc(){
  while(!CState){
    ReadEnc();
  }  
  encInit = 0;
}

void OutputValues(){  
    Serial.print(tc, 3);
    Serial.print(",");
    Serial.print(theta);
    Serial.print(",");
    Serial.println(X);
}

void systEval(){
  thetaDot = (theta-LastTheta)/(tc-LastTc);
  XDot = (X-LastX)/(tc-LastTc);
  LastTheta = theta;
  LastX = X;
  LastTc = tc;
}

void feedback(){
  targP = X*Kpc+XDot*Kdc;
  er = theta-targP;
  deltaV = er*Kpp+thetaDot*Kdp; 
  V += deltaV;
  V = min(V, 4000);
  V = max(V, -4000);
}
