const int Step = 34;
const int Dir  = 36;

void setup() {
  pinMode(Step, OUTPUT);
  pinMode(Dir, OUTPUT);
}

void loop() {
  digitalWrite(Dir, HIGH);
  for(int i = 0; i<200; i++){
    digitalWrite(Step, HIGH);
    delay(1);
    digitalWrite(Step, LOW);
    delay(1);
  }
  digitalWrite(Dir, LOW);
  for(int i = 0; i<200; i++){
    digitalWrite(Step, HIGH);
    delay(1);
    digitalWrite(Step, LOW);
    delay(1);
  } 
}
