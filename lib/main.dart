import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/notesmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //firebase creadianstionls for connecting firbase to flutter pass value
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 
      appId: 
      messagingSenderId:
      projectId: 
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 55, 128, 232),
        ),
      ),
      home: const MyHomePage(title: 'NoteApp'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isChecked = false;

  void onTick(bool? value) {
    setState(() {
      isChecked = value ?? false;
    });
  }

  //controller for getin data from textfild
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController decrcontroller = TextEditingController();

  // send data to firebase title and decription
  Future<void> sendData() async {
    final form = Notesmodel(
      Title: titlecontroller.text,
      Description: decrcontroller.text,
    );
    await FirebaseFirestore.instance.collection("forms").add(form.toJson());

    titlecontroller.clear();
    decrcontroller.clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Data sent successfully")));
  }

  //add note button create to show form
  Future Addnote() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titlecontroller,
                decoration: const InputDecoration(labelText: "Title"),
              ),

              TextField(
                controller: decrcontroller,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              const SizedBox(height: 10),
              Checkbox(value: false, onChanged: (context) {}),
              ElevatedButton(
                onPressed: () {
                  sendData();
                  Navigator.pop(context);
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("forms").snapshots(),
        builder: (context, snapshot) {
          final notes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              var data = notes[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['Title']),
                subtitle: Text(data['Description']),
                titleTextStyle: TextStyle(
                  color: const Color.fromARGB(255, 3, 143, 250),
                  fontSize: 30,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //here we call function to add notes
          Addnote();
        },
        child: const Text("Add"),
      ),
    );
  }
}
