import 'package:admin_livraison_jouets/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/simple_app_bar.dart';

class DeactiveUsersScreen extends StatefulWidget {
  const DeactiveUsersScreen({Key? key}) : super(key: key);

  @override
  State<DeactiveUsersScreen> createState() => _DeactiveUsersScreenState();
}

class _DeactiveUsersScreenState extends State<DeactiveUsersScreen> {
  QuerySnapshot? allusers;

  displayDialogBoxForUnBlockingAccount(userDocumentID) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Debloqué le compte ",
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 2,
              ),
            ),
          ),
          content: Text(
            "Etes vous sur de voulir activer ce compte?",
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> userDataMap = {
                  //change status to not approved
                  "status": "approved",
                };

                FirebaseFirestore.instance
                    .collection("users")
                    .doc(userDocumentID)
                    .update(userDataMap)
                    .then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const HomeScreen())));
                  SnackBar snackBar = const SnackBar(
                    content: Text(
                      "Compte ulilisateur debloqué",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .where("status", isEqualTo: "not approved")
        .get()
        .then((allActiveUsers) {
      setState(() {
        allusers = allActiveUsers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget displayDeactiveUsersDesign() {
      if (allusers != null) {
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: 1,//allusers!.docs.length,
          itemBuilder: (context, i) {
            return Card(
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage("images/abdou.png"),
                            // NetworkImage(
                            //   "https://firebasestorage.googleapis.com/v0/b/transfermoneyapp-eae83.appspot.com/o/users%2F1674140201469?alt=media&token=ba0a3475-959a-45e1-b729-d40c4f7f7bba",//allusers!.docs[i].get("photoUrl"),
                            // ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      title: Text(
                        "Abdou Khadre Ndiaye",//allusers!.docs[i].get("name"),
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.email,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            "gaoussound2@gmail.com",//allusers!.docs[i].get("email"),
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        displayDialogBoxForUnBlockingAccount(
                            allusers!.docs[i].id);
                      },
                      icon: const Icon(Icons.check_box),
                      label: Text(
                        "Activer".toUpperCase(),
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      } else {
        return Center(
          child: Text(
            "Aucune information ",
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xff1b232A),
      appBar: SimpleAppBar(
        title: "Tous les utilisateurs désactivées",
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: displayDeactiveUsersDesign(),
        ),
      ),
    );
  }
}
