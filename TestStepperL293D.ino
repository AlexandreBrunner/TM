const int a1 = 30;  //bleu
const int a2 = 31;  //jaune
const int b1 = 32;  //blanc
const int b2 = 33;  //orange

int StepCount = 0;

void setup() {
  pinMode(a1, OUTPUT);
  pinMode(a2, OUTPUT);
  pinMode(b1, OUTPUT);
  pinMode(b2, OUTPUT);
}

void loop() {
  StepCW(2);
}


void StepCW (int s){
  //switch (StepCount){
    //case 0:
    digitalWrite(a1, LOW);
    digitalWrite(a2, HIGH);
    digitalWrite(b1, LOW);
    digitalWrite(b2, LOW);
    delay(s);
    //break;
    //case 1:
    digitalWrite(a1, LOW);
    digitalWrite(a2, LOW);
    digitalWrite(b1, HIGH);
    digitalWrite(b2, LOW);
    delay(s);
    //break;
    //case 2:
    digitalWrite(a1, HIGH);
    digitalWrite(a2, LOW);
    digitalWrite(b1, LOW);
    digitalWrite(b2, LOW);
    delay(s);
    //break;
    //case 3:
    digitalWrite(a1, LOW);
    digitalWrite(a2, LOW);
    digitalWrite(b1, LOW);
    digitalWrite(b2, HIGH);
    delay(s);
    //break;
  //}
}
