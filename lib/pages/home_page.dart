import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/data.dart';
import '../size_config.dart';
import '../style/style.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal! * 17,
            ),
            child: const Column(
              children: [
                // User Info Area.
                UserInfo(),
                // SearchMedical Area.
                SearchMedical(),
                // Services Area.
                Services(),
                // Advertisement.
                Advertisement(),
              ],
            ),
          ),
          //Upcoming Appointments.
          UpcomingAppointments(userId: FirebaseAuth.instance.currentUser!.uid),
        ],
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return FutureBuilder<DocumentSnapshot>(
      future: firestore.collection('users').doc(user!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Error fetching user data'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Center(
            child: Text('No user data found'),
          );
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;
        var userName = userData['name'] ?? 'Unknown';

        return ListTile(
          contentPadding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical! * 3,
            bottom: 16.0,
          ),
          title: const Padding(
            padding: EdgeInsets.only(
              bottom: 7,
              top: 7,
            ),
            child: Text("👋 Hello!"),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(
              bottom: SizeConfig.blockSizeVertical! * 0,
            ),
            child: Text(
              userName,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          trailing: Container(
            height: 48,
            width: 48,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppStyle.profile),
                fit: BoxFit.cover,
                repeat: ImageRepeat.repeat,
              ),
              borderRadius: BorderRadius.all(Radius.circular(18.0)),
            ),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  width: 18.0,
                  height: 18.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppStyle.primarySwatch,
                    border: Border.all(
                      color: Colors.white,
                      width: 3.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SearchMedical extends StatelessWidget {
  const SearchMedical({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal! * 1),
      child: TextFormField(
        decoration: InputDecoration(
          filled: true,
          prefixIcon: CupertinoButton(
            onPressed: () {},
            child: SvgPicture.asset(AppStyle.searchIcon),
          ),
          suffixIcon: CupertinoButton(
            onPressed: () {},
            child: SvgPicture.asset(AppStyle.filterIcon),
          ),
          hintText: "Search...",
          fillColor: AppStyle.inputFillColor,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

class Services extends StatelessWidget {
  const Services({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical! * 7,
          ),
          child: Text(
            "Services",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: servicesList
              .map(
                (e) => CupertinoButton(
                  onPressed: () {
                    if (e.route != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => e.route!),
                      );
                    }
                  },
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: SizeConfig.blockSizeHorizontal! * 80,
                    height: SizeConfig.blockSizeVertical! * 40,
                    decoration: BoxDecoration(
                      color: e.color,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: SvgPicture.asset(e.image),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class Advertisement extends StatelessWidget {
  const Advertisement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.blockSizeVertical! * 7,
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffDCEDF9),
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal! * 17),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Get the Best\nMedical Service",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical! * 4),
                          Text(
                            "강동주 - 돌담병원\nDoldam Hospital",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1,
                                  fontSize: 11,
                                  height: 1.5,
                                ),
                          ),
                        ]),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical! * 8,
                        right: SizeConfig.blockSizeHorizontal! * 10),
                    child: Image.asset(AppStyle.image1),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class UpcomingAppointments extends StatelessWidget {
  final String userId;

  const UpcomingAppointments({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal! * 17,
          ),
          child: Text(
            "Upcoming Appointments",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.w700, letterSpacing: 1),
          ),
        ),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('bookings')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final bookings = snapshot.data!.docs;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 2.0,
                    bottom: 2.0,
                    right: 20.0,
                    left: 9.0,
                  ),
                  child: Row(
                    children: bookings
                        .map(
                          (booking) => CupertinoButton(
                            onPressed: () {},
                            padding: const EdgeInsets.only(
                              left: 14,
                            ),
                            child: Container(
                              height: SizeConfig.blockSizeVertical! * 50,
                              width: SizeConfig.blockSizeHorizontal! * 240,
                              decoration: BoxDecoration(
                                color: AppStyle
                                    .primarySwatch, // Customize the color
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(20),
                                    width: 51.46,
                                    height: 93.03,
                                    decoration: BoxDecoration(
                                      color: Colors.white12,
                                      borderRadius: BorderRadius.circular(17.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        booking['date'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        booking['time'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              letterSpacing: 1,
                                              color: Colors.white,
                                            ),
                                      ),
                                      Text(
                                        booking['doctorName'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.bold,
                                              height: 1.5,
                                              color: Colors.white,
                                            ),
                                      ),
                                      Text(
                                        booking['specialist'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.bold,
                                              height: 1.5,
                                              color: Colors.white60,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Failed to fetch upcoming appointments');
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }
}
