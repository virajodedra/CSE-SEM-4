// class Contact{
//   String name;
//   String age;
//
//   Contact({required this.name, required this.age});
//
//
// }
class Contact {
  String name;
  String age;

  Contact({required this.name, required this.age});
}

// class ContactManager {
//   // List to store contacts
//   final List<Contact> _contacts = [];
//
//   // Method to add a new contact
//   void addContact(String name, String age) {
//     final newContact = Contact(name: name, age: age);
//     _contacts.add(newContact);
//     print('Contact added: ${newContact.name}, Age: ${newContact.age}');
//   }
//
//   // Method to update a contact by name
//   void updateContact(String oldName, String newName, String newAge) {
//     for (var contact in _contacts) {
//       if (contact.name == oldName) {
//         contact.name = newName;
//         contact.age = newAge;
//         print('Contact updated: $newName, Age: $newAge');
//         return;
//       }
//     }
//     print('Contact not found: $oldName');
//   }
//
//   // Method to delete a contact by name
//   void deleteContact(String name) {
//     _contacts.removeWhere((contact) => contact.name == name);
//     print('Contact deleted: $name');
//   }
//
//   // Method to search for contacts by name
//   List<Contact> searchContact(String query) {
//     final results = _contacts
//         .where((contact) => contact.name.toLowerCase().contains(query.toLowerCase()))
//         .toList();
//     if (results.isEmpty) {
//       print('No contacts found for: $query');
//     } else {
//       print('Search results for "$query":');
//       for (var contact in results) {
//         print('${contact.name}, Age: ${contact.age}');
//       }
//     }
//     return results;
//   }
//
//   // Method to display all contacts
//   void displayContacts() {
//     if (_contacts.isEmpty) {
//       print('No contacts available.');
//     } else {
//       print('All Contacts:');
//       for (var contact in _contacts) {
//         print('${contact.name}, Age: ${contact.age}');
//       }
//     }
//   }
// }
