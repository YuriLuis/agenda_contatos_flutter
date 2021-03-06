import 'dart:io';

import 'package:agenda_contatos_flutter/helper/contato_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContatoPage extends StatefulWidget {
  final Contact contact;

  ContatoPage({this.contact});

  @override
  _ContatoPageState createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  Contact _contatoParaEditado;
  bool _userEdit = false;
  final _focusName = FocusNode();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.contact == null) {
      _contatoParaEditado = Contact();
    } else {
      _contatoParaEditado = Contact.fromMap(widget.contact.toMap());
      _nomeController.text = _contatoParaEditado.name;
      _emailController.text = _contatoParaEditado.email;
      _telefoneController.text = _contatoParaEditado.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black54,
          title: Text(_contatoParaEditado.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_contatoParaEditado.name != null &&
                _contatoParaEditado.name.isNotEmpty) {
              Navigator.pop(context,
                  _contatoParaEditado); //finaliza essa tela e volta para tela anterior!
            } else {
              FocusScope.of(context).requestFocus(_focusName);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.black54,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                child: Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _contatoParaEditado.img != null
                            ? FileImage(File(_contatoParaEditado.img))
                            : AssetImage("images/usuario_padrao.png"),
                        fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  // ignore: deprecated_member_use
                  ImagePicker.pickImage(source: ImageSource.camera)
                      .then((file) {
                    if (file == null) return;
                    setState(() {
                      _contatoParaEditado.img = file.path;
                    });
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _userEdit = true;
                  setState(() {
                    _contatoParaEditado.name = text;
                  });
                },
                focusNode: _focusName,
                controller: _nomeController,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text) {
                  _userEdit = true;
                  _contatoParaEditado.email = text;
                },
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Telefone"),
                onChanged: (text) {
                  _userEdit = true;
                  _contatoParaEditado.phone = text;
                },
                keyboardType: TextInputType.phone,
                controller: _telefoneController,
              ),
            ],
          ),
        ),
      ),
      // ignore: missing_return
      onWillPop: () => _requestPop(),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdit) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Altera????es?"),
              content: Text("Se sair as altera????es ser??o perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
