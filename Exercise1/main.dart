import 'dart:async';

void main() {
  profile();
  print();
  bolme();
  checkChargeStatus();
  myProfile();
}

//Exercise 1
void print() {
  print("Hello,World!");
}
//Exercise 2
void profile() {
  String name = "Beyza Cankurtaran";
  int age = 22;
  double height = 173;
  bool isStudent = true;

  print("Name: $name");
  print("Age: $age");
  print("Height: $height cm");
  print("Is a student: $isStudent");
}

// Exercise 3
void bolme() {
  int a = 40;
  int b = 50;
  int c = 60;

  int first = (a - b) * c ~/ (a + b);
  int second = (a * b * c);
  print(first * second);
}


//Exercise 4
void checkChargeStatus(int chargeLevel) {
  if (isValidChargeLevel(chargeLevel)) {
    if (chargeLevel == 100) {
      print("Telefon şarj edildi (Şarjın $chargeLevel)");
    } else if (chargeLevel > 20 && chargeLevel < 99) {
      print("Sarjın yeterli (Şarjın $chargeLevel)");
    } else if (chargeLevel < 20 && chargeLevel > 10) {
      print("Telefonu sarj edin. (Şarjın $chargeLevel)");
    } else if (chargeLevel <= 10) {
      print("Kritik sarj seviyesi (Şarjın $chargeLevel)");
    }
  } else {
    print("Telefon uzaydan herhalde  (Şarjın $chargeLevel)");
  }
}
bool isValidChargeLevel(int chargeLevel) {
  return chargeLevel >= 0 && chargeLevel <= 100;
}

//Exercise 5
void myProfile() {
  String name = "Beyza";
  int age = 22;
  double height = 173;
  String favoriteColor = "Purple";

  printUserInfo(name, age, height, favoriteColor);
}

void printUserInfo(String name, int age, double height, String favoriteColor) {
  print(
      "Merhaba, ben $name, $age yaşındayım. Boyum $height ve en sevdiğim renk $favoriteColor");
}

