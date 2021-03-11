import 'dart:io';
import 'package:agenda_contatos_flutter/helper/contato_helper.dart';
import 'package:agenda_contatos_flutter/view/contato_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Atributos
  ContactHelper helper = ContactHelper();
  List<Contact> listContacts = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.black54,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage(); //Cria novo contato!
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.black54,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: listContacts.length,
          // ignore: missing_return
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: listContacts[index].img != null
                          ? AssetImage(
                          "images/usuario_padrao.png") /*FileImage(File(listContacts[index].img))*/
                          : AssetImage("images/usuario_padrao.png")),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listContacts[index].name ?? "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        listContacts[index].email ?? "",
                        style: TextStyle(
                            fontSize: 18.0)
                    ),
                    Text(listContacts[index].phone ?? "",
                      style: TextStyle(
                          fontSize: 18.0
                      ),)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: (){
        _showContactPage(contact: listContacts[index]);
      },
    );
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContatoPage(contact: contact,))
    );
    if(recContact != null){
      if(contact != null){
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        print(list);
        listContacts = list;
      });
    });
  }
}
