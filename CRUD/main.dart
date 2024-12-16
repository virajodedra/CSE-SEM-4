import 'dart:io';
import 'demo/crud.dart';

void main() {
  Crud crud = Crud();
  print("Crud Program ..");
  int choice;
  do{
    print("Enter 1 to add user , 2 for list user, 3 for delete user and 4 for update user and 5 to EXIT! ");
    choice = int.parse(stdin.readLineSync()!);

    switch(choice){
      case 1 :
        print('Enter the name :');
        String name = stdin.readLineSync()!;
        print('Enter the roll number :');
        String roll = (stdin.readLineSync()!);
        print('Enter the email :');
        String email = stdin.readLineSync()!;
        crud.addUser(name: name, roll: roll, email: email);
        break;

      case 2 :
        List<Map<String,dynamic>> temp = crud.listUser();
        for(var element in temp){
          print(element);
        }
        break;

      case 3 :
        print("Enter the id to delete :");
        int id = int.parse(stdin.readLineSync()!);
        crud.deleteUser(id:id);
        break;

      case 4 :
        print("Enter the id  :");
        int id = int.parse(stdin.readLineSync()!);
        print('Enter the name :');
        String name = stdin.readLineSync()!;
        print('Enter the roll number :');
        String roll = (stdin.readLineSync()!);
        print('Enter the email :');
        String email = stdin.readLineSync()!;

        crud.updateUser(name: name, roll: roll, email: email, id: id);
        break;

      case 5:
        print('VISIT AGAIN');
        break;
    }
  }
  while(choice != 5);

}


