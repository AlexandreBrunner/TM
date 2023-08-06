/*
--------------------------------------------------------
Ce code permet de déduire l'angle relatif donné par un
encodeur rotatif. Pour l'HEDS 5504 les pins de gauche 
à droite sont: GND, Channel C, Channel A, Vcc, Channel B.
Ne pas oublier de mettre des résistance de 2KOhm en 
parallèle des trois canaux pour éviter la tension indue.
--------------------------------------------------------
*/
const int CHA = 31; 
const int CHB = 30; 
const int CHC = 32; 

bool lastState = 0;
bool AState = 0;
bool BState = 0;
bool CState = 0;
int count = 0;

void setup() {
Serial.begin(500000);
pinMode(CHA, INPUT);
pinMode(CHB, INPUT);
pinMode(CHC, INPUT);
}

void loop() {
  AState = digitalRead(CHA);
  BState = digitalRead(CHB);
  CState = digitalRead(CHC);
  
  if (lastState != AState){
    if(AState == BState){
      count++;
    }else{
      count--;
    }
    lastState = AState;
    Serial.print(count);
    Serial.print(",  ");
    Serial.print(millis());
    Serial.println(";");

    if(CState){
      count = 0;

    }
  }

}
