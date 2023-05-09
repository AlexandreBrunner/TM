const int StepPin = 34;
const int DirPin  = 36;

void setup() {
  pinMode(StepPin, OUTPUT);
  pinMode(DirPin, OUTPUT);
}

void loop() {
  for(int i = 0; i<200; i++){
    Step(HIGH, 2, StepPin, DirPin);
  }
  for(int i = 0; i<200; i++){
    Step(LOW, 2, StepPin, DirPin);
  }
}

void Step (bool Dir, int v, int StepPin, int DirPin){
  digitalWrite(DirPin, Dir);
  digitalWrite(StepPin, HIGH);
  delay(v);
  digitalWrite(StepPin, LOW);
  delay(v);
}
