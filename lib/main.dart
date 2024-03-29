import 'dart:convert';
import 'package:notesapp/additem.dart';
import 'package:notesapp/edititem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const NotesApp());
}
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//   await SystemChrome.setPreferredOrientations(
//       [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//   runApp(
//     DevicePreview(
//       enabled: true,
//       builder: (context) => const NotesApp(),
//     ),
//   );
// }

class NotesApp extends StatefulWidget {
  const NotesApp({super.key});

  @override
  NotesAppState createState() => NotesAppState();
}

class NotesAppState extends State<NotesApp> {
  /*
*The GlobalKey<ScaffoldState> is a special key used to uniquely identify a Scaffold widget in your widget tree. It allows you to perform actions on the Scaffold from anywhere in your widget tree, such as opening or closing the drawer, showing a snackbar, or accessing the scaffold's state.

*In the provided code, _scaffoldKey is declared as a GlobalKey<ScaffoldState> and assigned to the key property of the Scaffold. This allows you to access the scaffold's state using this key.

*For example, if you want to open the drawer programmatically from anywhere in your widget tree, you can use _scaffoldKey.currentState!.openDrawer();.

*Using GlobalKey comes in handy when you need to interact with widgets that are not directly accessible from the current widget's context. It's a way to establish a connection to specific widgets across your widget tree.
*/
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Map<String, String>> _data = [];
  ThemeMode _currentThemeMode = ThemeMode.light;
  final Uri _url = Uri.parse(
      'https://doc-hosting.flycricket.io/notes-app-privacy-policy/779e63ad-9196-4172-a53f-35d708a62db5/privacy');
  final Uri _url1 = Uri.parse(
      'https://doc-hosting.flycricket.io/notes-app-terms-of-use/845efcec-a199-4af6-93c6-4b5caed93db8/terms');

  final List<Color> _tileColors = [
    Colors.blue,
    Colors.green,
    Colors.lightBlue,
    Colors.pink,
    Colors.purple,
  ];
  int _currentColorIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? notes = prefs.getStringList('notes');
    if (notes != null) {
      setState(() {
        _data.clear();
        for (String note in notes) {
          _data.add(Map<String, String>.from(
              json.decode(note))); // Decode and add each note
        }
      });
    }
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notes = _data.map((note) => json.encode(note)).toList();
    prefs.setStringList('notes', notes);
  }

  // Function to get the next color from the list
  Color _getNextColor() {
    final color = _tileColors[_currentColorIndex];
    _currentColorIndex = (_currentColorIndex + 1) % _tileColors.length;
    return color;
  }

  Future<void> _openURL() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> _openURL1() async {
    if (!await launchUrl(_url1)) {
      throw Exception('Could not launch $_url1');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 165, 136, 214)),
        useMaterial3: true,
      ),
      themeMode: _currentThemeMode,
      // theme: ThemeData.light(), // Define your light theme
      darkTheme: ThemeData.dark(), // Define your dark theme
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) => Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            key: const Key('Notes App'), // Unique key
            // leading: IconButton(
            //   icon: const Icon(Icons.menu),
            //   onPressed: () {
            //     // Add your action here
            //   },
            // ),

            title: const Text(
              'Notes App',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: <Widget>[
              // IconButton(
              //   icon: const Icon(Icons.search),
              //   onPressed: () {
              //     // Add your search action here
              //   },
              // ),
              // ******************
              // IconButton(
              //   icon: const Icon(Icons.settings),
              //   onPressed: () {
              //     // Add your settings action here
              //   },
              // ),
              // ************************
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(_currentThemeMode == ThemeMode.light
                      ? Icons.light_mode
                      : Icons.dark_mode),
                  onPressed: () {
                    setState(() {
                      _currentThemeMode = _currentThemeMode == ThemeMode.light
                          ? ThemeMode.dark
                          : ThemeMode.light;
                    });
                  },
                ),
              ),
            ],
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Color.fromARGB(255, 13, 214, 40)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            elevation: 1.0,
            scrolledUnderElevation: 2.0,
            notificationPredicate: (ScrollNotification notification) {
              return true; // React to all scroll notifications
            },
            shadowColor: Colors.grey,
            surfaceTintColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20.0),
              ),
            ),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.white),
            actionsIconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
            excludeHeaderSemantics: true,
            titleSpacing: 0.0,
            toolbarOpacity: 0.8,
            bottomOpacity: 0.9,
            toolbarHeight: 60.0,
            leadingWidth: 60.0,
            toolbarTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            titleTextStyle: const TextStyle(
              fontStyle: FontStyle.italic,
            ),
            // systemOverlayStyle: SystemUiOverlayStyle.light,
            forceMaterialTransparency: true,
            clipBehavior: Clip.antiAlias,
          ),
          body: ListView.builder(
            itemCount: _data.length,
            itemBuilder: (context, index) {
              final tileColor = _getNextColor(); // Get the next color
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black87, // Choose your border color
                      width: 1.0, // Adjust the border width as needed
                    ),
                    borderRadius: BorderRadius.circular(
                        8.0), //* Adjust the border radius as needed
                    color: tileColor, // Apply the color to the container
                  ),
                  child: ListTile(
                    title: Text(
                      _data[index]['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    subtitle: Text(
                      _data[index]['body']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    // trailing: IconButton(
                    //   icon: const Icon(Icons.delete),
                    //   onPressed: () {
                    //     setState(() {
                    //       _data.removeAt(index);
                    //       _saveData(); // Call save method after deleting a note
                    //     });
                    //   },
                    // ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: const Text(
                                'Are you sure you want to delete this item?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _data.removeAt(index);
                                    _saveData(); // Call save method after deleting a note
                                  });
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // ********************
                    // onTap: () async {
                    //   final result = await showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       String title = _data[index]['title']!;
                    //       String body = _data[index]['body']!;
                    //       return AlertDialog(
                    //         title: const Text('Edit Data'),
                    //         content: Column(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             TextField(
                    //               decoration:
                    //                   const InputDecoration(labelText: 'Title'),
                    //               onChanged: (value) => title = value,
                    //               controller:
                    //                   TextEditingController(text: title),
                    //             ),
                    //             TextField(
                    //               minLines: 5,
                    //               maxLines: 8,
                    //               decoration: const InputDecoration(
                    //                   labelText: 'Description'),
                    //               onChanged: (value) => body = value,
                    //               controller: TextEditingController(text: body),
                    //             ),
                    //           ],
                    //         ),
                    //         actions: [
                    //           TextButton(
                    //             onPressed: () {
                    //               Navigator.pop(context, null);
                    //             },
                    //             child: const Text('Cancel'),
                    //           ),
                    //           ElevatedButton(
                    //             onPressed: () {
                    //               Navigator.pop(
                    //                   context, {'title': title, 'body': body});
                    //             },
                    //             child: const Text('Update'),
                    //           ),
                    //         ],
                    //       );
                    //     },
                    //   );
                    //   if (result != null) {
                    //     setState(() {
                    //       _data[index]['title'] = result['title']!;
                    //       _data[index]['body'] = result['body']!;
                    //       _saveData(); // Call save method after editing a note
                    //     });
                    //   }
                    // },
                    // **********************
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditItemPage(
                            initialTitle: _data[index]['title']!,
                            initialBody: _data[index]['body']!,
                          ),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          _data[index]['title'] = result['title']!;
                          _data[index]['body'] = result['body']!;
                          _saveData(); // Call save method after editing a note
                        });
                      }
                    },
                    // ******************
                  ),
                ),
              );
            },
          ),
          // ********************************
          drawer: Drawer(
            // Add a Drawer widget here
            // backgroundColor: Colors.black,
            backgroundColor: _currentThemeMode == ThemeMode.light
                ? Colors.white
                : Colors.black,

            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: const Text(
                    "Hi 👋👋",
                    style: TextStyle(),
                  ),
                  accountEmail: const Text("Welcome to Notes App"),
                  decoration: const BoxDecoration(
                    color: Colors.blue, // Change background color as desired
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://images.pexels.com/photos/531880/pexels-photo-531880.jpeg?auto=compress&cs=tinysrgb&w=600',
                      ), // Replace with your network image URL
                      fit: BoxFit.cover,
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                    // backgroundImage: AssetImage(
                    //   'assets/images/sk.png',
                    // ),
                    child: ClipOval(
                      child: Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9A5EnB-blCGhekD8xzY6HbwxtbLBbhWzgPzahkqPEqFJyXHOba-k2KjiX8Kb_dkVZHl4&usqp=CAU',
                      ),
                    ),
                  ),
                ),
                ListTile(
                  // tileColor: Colors.indigo,
                  leading: const Icon(
                    Icons.home,
                    color: Colors.blue,
                    size: 25, // Example color
                  ),
                  title: const Text(
                    'Home',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    // Add your navigation logic here
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  // tileColor: Colors.blueAccent,
                  leading: const Icon(
                    Icons.privacy_tip,
                    color: Colors.green,
                    size: 25,
                  ),
                  title: const Text(
                    'Privacy Policies',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    // Navigator.pop(context);
                    // const AboutmePage();
                    _openURL();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  // tileColor: Colors.cyan,
                  leading: const Icon(
                    Icons.policy,
                    color: Colors.red,
                    size: 25, // Example color
                  ),
                  title: const Text(
                    'Terms & Conditions',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // Navigator.pop(context);
                    // const AboutmePage();
                    _openURL1();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  // tileColor: const ColorScheme.dark().primary,
                  leading: const Icon(
                    Icons.star,
                    color: Color.fromARGB(255, 20, 8, 198),
                    size: 25, // Example color
                  ),
                  title: const Text(
                    'Rate Us',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                // Add more list items as needed
              ],
            ),
          ),

          // ********************************
          // floatingActionButton: FloatingActionButton(
          floatingActionButton: FloatingActionButton.extended(
            // onPressed: () async {
            //   final result = await showDialog(
            //     context: context,
            //     builder: (context) {
            //       String title = '';
            //       String body = '';
            //       return AlertDialog(
            //         title: const Text('Add Data'),
            //         content: Column(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             TextField(
            //               decoration: const InputDecoration(labelText: 'Title'),
            //               onChanged: (value) => title = value,
            //             ),
            //             TextField(
            //               minLines: 5,
            //               maxLines: 8,
            //               decoration: const InputDecoration(labelText: 'Description'),
            //               onChanged: (value) => body = value,
            //             ),
            //           ],
            //         ),
            //         actions: [
            //           TextButton(
            //             onPressed: () {
            //               Navigator.pop(context, null);
            //             },
            //             child: const Text('Cancel'),
            //           ),
            //           ElevatedButton(
            //             onPressed: () {
            //               Navigator.pop(
            //                   context, {'title': title, 'body': body});
            //             },
            //             child: const Text('Add'),
            //           ),
            //         ],
            //       );
            //     },
            //   );
            //   if (result != null) {
            //     setState(() {
            //       _data.add(result);
            //       _saveData(); // Call save method after adding a note
            //     });
            //   }
            // },
            // child: const Icon(Icons.add),

            // *******************************
            label: const Text('Add Item'),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddItemPage(),
                ),
              );

              if (result != null) {
                setState(() {
                  _data.add(result);
                  _saveData(); // Call save method after adding a note
                });
              }
            },
            // *********************
          ),
        ),
      ),
    );
  }
}
