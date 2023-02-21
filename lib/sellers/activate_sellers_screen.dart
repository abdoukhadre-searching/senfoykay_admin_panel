import 'package:admin_livraison_jouets/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/simple_app_bar.dart';

class ActiveSellersScreen extends StatefulWidget {
  const ActiveSellersScreen({Key? key}) : super(key: key);

  @override
  State<ActiveSellersScreen> createState() => _ActiveSellersScreenState();
}

class _ActiveSellersScreenState extends State<ActiveSellersScreen> {
  QuerySnapshot? allusers;

  displayDialogBoxForBlockingAccount(userDocumentID) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Bloqué le compte",
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
            "Vous etes entrain de bloque ce compte ?",
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
              child: const Text("Non"),
            ),
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> userDataMap = {
                  //change status to not approved
                  "status": "not approved",
                };

                FirebaseFirestore.instance
                    .collection("sellers")
                    .doc(userDocumentID)
                    .update(userDataMap)
                    .then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) =>const  HomeScreen())));
                  SnackBar snackBar = const SnackBar(
                    content: Text(
                      "Compte bloqué",
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
              child: const Text("Oui"),
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
        .collection("sellers")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allActiveUsers) {
      setState(() {
        allusers = allActiveUsers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget displayActiveUsersDesign() {
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
                        height: 65,
                        width: 65,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              allusers!.docs[i].get("sellerAvatarUrl"),
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      title: Text(
                        "Kidz Palace",//allusers!.docs[i].get("sellerName"),
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
                            "Kidz_Palace@gmail.com",//allusers!.docs[i].get("sellerEmail"),
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
                        SnackBar snackBar = const SnackBar(
                          content: Text(
                            "Revenue: 5500 Fcfa",//.toUpperCase() +  "\$" +   allusers!.docs[i].get("earnings").toString(),
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      icon: const Icon(Icons.monetization_on),
                      label: Text(
                        "5500 Fcfa",// + allusers!.docs[i].get("earnings").toString(),
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        displayDialogBoxForBlockingAccount(
                            allusers!.docs[i].id);
                      },
                      icon: const Icon(Icons.disabled_by_default),
                      label: Text(
                        "Bloque son compte".toUpperCase(),
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
        title: "Vendeurs actifs",
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: displayActiveUsersDesign(),
        ),
      ),
    );
  }
}