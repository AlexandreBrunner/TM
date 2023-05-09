const int CHA = 30; //jaune
const int CHB = 32; //blanc/gris
const int CHC = 34; //orange

void setup() {
Serial.begin(500000);
pinMode(CHA, INPUT);
pinMode(CHB, INPUT);
pinMode(CHC, INPUT);
}

void loop() {
  while (!digitalRead(CHC)){
  Serial.print(digitalRead(CHA));
  Serial.println(digitalRead(CHB));
  }
  while(1){}
}
