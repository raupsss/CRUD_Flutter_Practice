// ignore_for_file: prefer_const_constructors, must_be_immutable, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

TextEditingController inputName = TextEditingController();
TextEditingController inputEmail = TextEditingController();
TextEditingController inputGender = TextEditingController();

Future<http.Response> getData() async {
  var result =
      await http.get(Uri.parse("http://localhost:8082/api/user/getAllUser"));

  return result;
}

Future<http.Response> postData() async {
  Map<String, dynamic> data = {
    "name": inputName.text,
    "email": inputEmail.text,
    "gender": inputGender.text
  };
  var result = await http.post(
    Uri.parse("http://localhost:8082/api/user/createUser"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(data),
  );
  return result;
}

Future<http.Response> updateData(id) async {
  Map<String, dynamic> data = {
    "name": inputName.text,
    "email": inputEmail.text,
    "gender": inputGender.text
  };
  var result = await http.put(
    Uri.parse("http://localhost:8082/api/user/updateUser/${id}"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(data),
  );

  return result;
}

Future<http.Response> deleteData(id) async {
  var result = await http.delete(
    Uri.parse("http://localhost:8082/api/user/deleteUser/${id}"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
  );
  return result;
}

class NetworkingHttps extends StatefulWidget {
  NetworkingHttps({super.key});

  @override
  State<NetworkingHttps> createState() => _NetworkingHttpsState();
}

class _NetworkingHttpsState extends State<NetworkingHttps> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // print(postData());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Networking Https",
        ),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> json = jsonDecode(snapshot.data!.body);
              return ListView.builder(
                itemCount: json.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(json[index]['name'][0]),
                        backgroundColor: Colors.amber,
                      ),
                      title: Text(json[index]['name']),
                      subtitle: Text(json[index]["email"]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: (() {
                              inputName.text = json[index]['name'];
                              inputEmail.text = json[index]['email'];
                              inputGender.text = json[index]['gender'];
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: const Text(
                                          'Update User',
                                          textAlign: TextAlign.center,
                                        ),
                                        content: Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Name cannot be empty";
                                                  }
                                                  return null;
                                                },
                                                controller: inputName,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Name',
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Email cannot be empty";
                                                  }
                                                  if (!EmailValidator.validate(
                                                      value)) {
                                                    return "Please insert correct email";
                                                  }
                                                  return null;
                                                },
                                                controller: inputEmail,
                                                decoration: InputDecoration(
                                                  // border: OutlineInputBorder(),
                                                  labelText: 'Email',
                                                  // hintText: "Hint Text",
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),

                                              // TextFormField(
                                              //   controller: inputGender,
                                              //   decoration: InputDecoration(
                                              //     border: OutlineInputBorder(),
                                              //     labelText: 'Gender',
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  inputName.clear();
                                                  inputEmail.clear();
                                                  inputGender.clear();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Cancel',
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await updateData(
                                                      json[index]['id']);
                                                  inputName.clear();
                                                  inputEmail.clear();
                                                  inputGender.clear();
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          )
                                        ],
                                      ));
                            }),
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              await deleteData(json[index]['id']);

                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text(
                'Add User',
                textAlign: TextAlign.center,
              ),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name cannot be empty";
                        }
                        return null;
                      },
                      controller: inputName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email cannot be empty";
                        }
                        if (!EmailValidator.validate(value)) {
                          return "Please insert correct email";
                        }
                        return null;
                      },
                      controller: inputEmail,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: inputGender,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Gender',
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        inputName.clear();
                        inputEmail.clear();
                        inputGender.clear();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await postData();
                          inputName.clear();
                          inputEmail.clear();
                          inputGender.clear();
                          Navigator.pop(context);
                          setState(() {});
                        }
                      },
                      child: const Text('OK'),
                    ),
                  ],
                )
              ],
            ),
          );
          //
        },
      ),
    );
  }
}
