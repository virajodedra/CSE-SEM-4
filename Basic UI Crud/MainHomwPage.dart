import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testapp/demoscreens/NameDetails.dart';

import 'NameDetails.dart';

class HomePageDemoTest extends StatefulWidget {
  const HomePageDemoTest({super.key});

  @override
  State<HomePageDemoTest> createState() => _HomePageDemoTestState();
}

class _HomePageDemoTestState extends State<HomePageDemoTest> {
  TextEditingController nameCountroller = TextEditingController();
  TextEditingController ageCountroller = TextEditingController();
  List<Contact> contacts = List.empty(growable: true);
  List<Contact> allContacts = List.empty(growable: true);

  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Simple CRUD Page',
          style: TextStyle(color: Colors.white, backgroundColor: Colors.blue),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: nameCountroller,
                decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your Name ',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: ageCountroller,
                decoration: InputDecoration(
                    labelText: 'Age',
                    hintText: 'Enter your Age ',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
            ),
            SizedBox(
              height: 35,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    // minWidth: double.infinity,
                    onPressed: () {
                      String name = nameCountroller.text.trim();
                      String age = ageCountroller.text.trim();

                      if(name.isNotEmpty && age.isNotEmpty){
                        setState(() {
                          nameCountroller.text = '';
                          ageCountroller.text = '';
                          contacts.add(Contact(name: name, age: age));
                          allContacts.add(Contact(name: name, age: age));
                        });
                      }

                    },
                    child: Text('Submit'),
                    color: Colors.teal,
                    textColor: Colors.white,
                  ),
                  MaterialButton(
                    // minWidth: double.infinity,
                    onPressed: () {
                      String name = nameCountroller.text.trim();
                      String age = ageCountroller.text.trim();
                      if(name.isNotEmpty && age.isNotEmpty){
                        setState(() {
                          nameCountroller.text = '';
                          ageCountroller.text = '';
                          contacts[selectedIndex].name = name;
                          contacts[selectedIndex].age = age;
                          allContacts[selectedIndex].name = name;
                          allContacts[selectedIndex].age = age;
                          selectedIndex = -1;
                        });
                      }
                    },
                    child: Text('Update'),
                    color: Colors.teal,
                    textColor: Colors.white,
                  ),
                  MaterialButton(
                    onPressed: () {
                      String searchQuery = nameCountroller.text.trim().toLowerCase()  ;

                      if (searchQuery.isNotEmpty) {
                        setState(() {
                          // Filter contacts by name or age
                          contacts = contacts.where((contact) {
                            return contact.name.toLowerCase().contains(searchQuery) ||
                                contact.age.contains(searchQuery);
                          }).toList();
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Enter a query to search')),
                        );
                      }
                    },
                    child: const Text('Search'),
                    color: Colors.teal,
                    textColor: Colors.white,
                  ),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        // Restore the original contact list
                        contacts = List.from( allContacts);
                        nameCountroller .clear(); // Clear search field
                      });
                    },
                    child: const Text('Back'),
                    color: Colors.grey,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            contacts.isEmpty ? Text(' No Entries Yet', style: TextStyle(color: Colors.grey, fontSize: 22),) :
            Expanded(
              child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) => getRow(index)
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget getRow(int index){
    return Card(
      child: (
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contacts[index].name, style: TextStyle(fontWeight: FontWeight.bold, ),),
                Text(contacts[index].age, style: TextStyle(color: Colors.blueGrey),)
              ],
            ),
            trailing: SizedBox(
              width: 70,
              child: Row(
                children: [
                  InkWell(
                    onTap:((){
                      nameCountroller.text = contacts[index].name;
                      ageCountroller.text  = contacts[index].age;

                      setState(() {
                        selectedIndex = index;
                      });
                    }),
                      child: Icon(Icons.edit)
                  ),
                  SizedBox(width: 20,),
                  InkWell(
                      onTap:((){
                        setState(() {
                          contacts.removeAt(index);
                          allContacts.removeAt(index);
                        });
                      }),
                      child : Icon(Icons.delete)
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}


