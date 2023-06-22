/*
 * stabiliser un pendule inverse a la verticale:
 * 
 * - attendre l'initialisation du Stepper
 * - attendre que le pendule se stabilise vers sa position 
 *   d'equilibre stable (signal moniteur serie / buzzer)
 * - amener le pendule a la verticale vers le haut 
 *   (signal moniteur serie / buzzer)
 * - stabilisation
 */

 
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

//variables for stabilisation

float theta = 0.00;
float PosX = 0;
const float w = 0.95*sqrt(1.5*9.81/0.49); 
int encInit = 0;

void setup() {
  Serial.begin(250000);
  
  //Define Switch and encodeur as input
  pinMode(CHA, INPUT);
  pinMode(CHB, INPUT);
  pinMode(CHC, INPUT);

  pinMode(SwPin, INPUT);

  //initiate the stepper position
  InitStepper();

  delay(3000);  //wait for the pendulum to stabilize
  encInit = 500 - ReadEnc();   //initate the pendulum's angle
  
  //set max speed and max acceleration for the stepper
  stepper.setMaxSpeed(4000);
  stepper.setAcceleration(13000000);
}

void loop() {
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
        encCount = 0;
    }
//    Serial.print(encCount);
//    Serial.print(",  ");
//    Serial.print(millis());
//    Serial.println(";");
  }
  return encCount;
}
