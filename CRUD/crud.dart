class Crud{
  List<Map<String,dynamic>> userList = [];

  void addUser({required name, required roll, required email}){
    Map<String,dynamic> map = {};
    map[name]  = name;
    map[roll] = roll;
    map[email] = email;
    userList.add(map);
  }

  List<Map<String, dynamic>> listUser(){
    return userList;
  }

  void deleteUser({required id}){
    userList.removeAt(id);
  }

  void updateUser({required name, required roll, required email, required id}){
    Map<String, dynamic> update = {};
    update[name] = name;
    update[roll] = roll;
    update[email] = email;
    userList[id] = update;
  }
}
