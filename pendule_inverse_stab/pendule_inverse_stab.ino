#include <AccelStepper.h>

// Define a stepper and the pins it will use
AccelStepper stepper(2, 51, 50);

// Define a pin for the end switch
const int SwPin = 40;

//Define pins for the encoder HEDS 5504: Channel A, channel B, channel C
const int CHA = 31;
const int CHB = 30;
const int CHC = 32;

bool AState = LOW;
bool BState = LOW;
bool CState = LOW;

bool lastEnc = LOW;
int encCount = 0;
int encInit = 0;

//variables for PID
const float radConvert = 3.1416/500.0;
float theta, thetaDot, tc, LastTheta, LastTc;
long X, XDot, LastX;
const float deltaTc = 0.1; 

void setup() {

  //initiate serial communication
  Serial.begin(9600);
  
  //Define Switch and encodeur as input
  pinMode(CHA, INPUT);
  pinMode(CHB, INPUT);
  pinMode(CHC, INPUT);

  pinMode(SwPin, INPUT);

  //initiate the stepper position
//  InitStepper();
//
//  delay(3000);  //wait for the pendulum to stabilize
//  
//  //initate the pendulum's angle
//  encCount = 0;   
//  encInit = 500;
//  Serial.println("INITIATED");
//
//  //wait for the user to start stabilisation
//  while(!Serial.available()){
//    Serial.println(ReadEnc());
//  }
//
//  Serial.println("START");  
      
  //set max speed and max acceleration for the stepper
  stepper.setMaxSpeed(1);
  stepper.setAcceleration(13000000);
  
}

void loop() {

  tc = millis()/1000.0;
  theta = ReadEnc()*radConvert;
  X = stepper.currentPosition();

  stepper.moveTo(10);
  stepper.run();
  
  if (tc - LastTc > deltaTc){
    systEval();
    displayValues();
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
  }
  return encCount;
}

void displayValues(){  
    Serial.print("theta: ");
    Serial.print(theta);
    Serial.print(", thetaDot: ");
    Serial.print(thetaDot);
    Serial.print(",  X: ");
    Serial.print(X);
    Serial.print(", XDot: ");
    Serial.print(XDot);
    Serial.print(",  time: ");
    Serial.println(tc);
}

void systEval(){
  thetaDot = (theta-LastTheta)/(tc-LastTc);
  XDot = (X-LastX)/(tc-LastTc);
  LastTheta = theta;
  LastX = X;
  LastTc = tc;

  
}
