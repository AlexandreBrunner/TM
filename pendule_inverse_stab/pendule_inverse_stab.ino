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

//variables for data collection
const int dataSize = 1000;
float thetaS [dataSize];
float thetaDotS [dataSize];
int tcS [dataSize];

int Lcount = 0;
int SaveIndex = 0;
const int saveInterval = 10;

//variables for PID
float theta;
float thetaDot, tc;
float LastTheta, LastTc;

void setup() {

  //initiate serial communication
  Serial.begin(250000);
  
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
  stepper.setMaxSpeed(4000);
  stepper.setAcceleration(13000000);
  
}

void loop() {

  systEval();
  
  if (Lcount<dataSize*saveInterval && Lcount%saveInterval == 0){
    thetaS [SaveIndex] = theta;
    thetaDotS [SaveIndex] = thetaDot;
    tcS [SaveIndex] = millis();
    
    SaveIndex++;
  }
  
  if (Lcount>dataSize*saveInterval){
    displayValues();
  }
  
  Lcount ++;
  Serial.println(SaveIndex);
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
//    Serial.print(encCount-encInit);
//    Serial.print(",  ");
//    Serial.print(millis());
//    Serial.println(",  ");
  }
  return encCount;
}

void displayValues(){  
    Serial.println("DISPLAYING VALUES");
    delay(3000);
    for (int i = 0; i<dataSize; i++){
      Serial.print(thetaS[i]);
      Serial.print(",  ");
      Serial.print(thetaDotS[i], 4);
      Serial.print(",  ");
//      Serial.print(XS[i]);
//      Serial.print(",  ");
//      Serial.print(XDotS[i]);
//      Serial.print(",  ");
      Serial.print(tcS[i]);
      Serial.println(";");
        
    }
    while(1){
      
    }
}

void systEval(){
  theta = ReadEnc()*3.1416/500.0;
  tc = millis()/1000.0;
  thetaDot = (theta-LastTheta)/(tc-LastTc);
  LastTheta = theta;
  LastTc = tc;
}
