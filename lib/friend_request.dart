import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readx/controllers/user_controller.dart';
import 'package:readx/firebase_crud.dart';
import 'package:readx/main.dart';
import 'package:readx/models/user_model.dart';
import 'package:readx/notification_model.dart';
import 'package:readx/utils/toast_util.dart';

// List<UserSuggestion> list = [
//   UserSuggestion("Ryan Reynolds", "assets/reynolds.png", "3 mutual friends"),
//   UserSuggestion("Ryan Reynolds", "assets/reynolds.png", "3 mutual friends"),
//   UserSuggestion("Professor Xavier", "assets/xavier.png", "12 mutual friends"),
//   UserSuggestion("Pepper Potts", "assets/pepper.jpg", "112 mutual friends"),
//   UserSuggestion("Wanda Maximoff", "assets/wanda.jpg", "4 mutual friends"),
//
//   UserSuggestion("Florance Pugh", "assets/florance.png", "4 mutual friends"),
//   UserSuggestion("Florance Pugh", "assets/florance.png", "4 mutual friends"),
//   UserSuggestion("Florance Pugh", "assets/florance.png", "4 mutual friends"),
//   UserSuggestion("Florance Pugh", "assets/florance.png", "4 mutual friends"),
//   UserSuggestion("Florance Pugh", "assets/florance.png", "4 mutual friends"),
// ];

class RequestsWidget extends StatefulWidget {
  const RequestsWidget({Key? key}) : super(key: key);

  @override
  State<RequestsWidget> createState() => _RequestsWidgetState();
}

class _RequestsWidgetState extends State<RequestsWidget> {
  List<UserModel> myFriends = [];
  List<UserModel> unknownUsers = [];
  List<UserModel> incomingReqUsers = [];
  final userController = Get.find<UserController>();

  Future getUserData() async {
    userController.loggedInUser =
        (await getIt<FirebaseCrud>().getUser(userController.loggedInUser!.id!));
    // if (userController.loggedInUser.sentFriendIds)
  }

  Future getAllUsers() async {
    unknownUsers.clear();
    incomingReqUsers.clear();
    print('my id ${userController.loggedInUser!.id}');
    final allUsers = await getIt<FirebaseCrud>().getAllUsers();
    for (int i = 0; i < allUsers.length; i++) {
      if (allUsers[i].id != userController.loggedInUser!.id &&
          !(allUsers[i].friendIds ?? [])
              .contains(userController.loggedInUser!.id)) {
        if (!(allUsers[i].receivedFriendIds ?? [])
            .contains(userController.loggedInUser!.id)) {
          unknownUsers.add(allUsers[i]);
        }
      }

      if (allUsers[i].id != userController.loggedInUser!.id &&
          (allUsers[i].sentFriendIds ?? [])
              .contains(userController.loggedInUser!.id)) {
        incomingReqUsers.add(allUsers[i]);
      }

      if (allUsers[i].id != userController.loggedInUser!.id &&
          (allUsers[i].friendIds ?? [])
              .contains(userController.loggedInUser!.id)) {
        myFriends.add(allUsers[i]);
      }


    }
    setState(() {});
  }

  @override
  void initState() {
    getAllUsers();
    super.initState();
  }

  Widget addFriendWidget(UserModel user) {
    return Card(
      margin: const EdgeInsets.fromLTRB(2, 1, 2, 1),
      elevation: 0.0,
      color: ThemeColors.blueNotification,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (user.image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(80.0),
                    child: Image.network(
                      user.image!,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  ClipRRect(
                    borderRadius: BorderRadius.circular(80.0),
                    child: Image.asset(
                      'assets/user.png',
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                          child: Text(
                            user.name ?? '',
                            style: requestTitle(),
                            textAlign: TextAlign.start,
                          ),
                        )),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //         child: Padding(
                    //       padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                    //       child: Text(
                    //         // item.sMutual,
                    //         '${(item.friendIds ?? []
                    //             .contains(userController.loggedInUser
                    //             ?.friendIds ?? []))}',
                    //         style: notificationTime(),
                    //         textAlign: TextAlign.start,
                    //       ),
                    //     ))
                    //   ],
                    // ),
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                          child: Text(
                            // item.sMutual,
                            '${user.id}',
                            style: notificationTime(),
                            textAlign: TextAlign.start,
                          ),
                        ))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: TextButton(
                          onPressed: () async {
                            await getIt<FirebaseCrud>().sendFriendReq(
                              userController.loggedInUser!.id!,
                              user.id!,
                              userController.loggedInUser!,
                            );
                            await getAllUsers();
                            showToast('Friend Request Sent');
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Add Friend",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                )
                              ],
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff1773EA)),
                          ),
                        )),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: TextButton(
                                onPressed: () {},
                                child: Text("Remove",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14)),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xffdcdcdc)),
                                )))
                      ],
                    )
                  ],
                )),
              ],
            ),
            //Row(children: [Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text(item.nBody, style: AppTheme.nbodyText, textAlign: TextAlign.start,),))],)
          ],
        ),
      ),
    );
  }

  Widget friendReqWidget(UserModel user) {
    return Card(
      margin: const EdgeInsets.fromLTRB(2, 1, 2, 1),
      elevation: 0.0,
      color: ThemeColors.blueNotification,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (user.image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(80.0),
                    child: Image.network(
                      user.image!,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  ClipRRect(
                    borderRadius: BorderRadius.circular(80.0),
                    child: Image.asset(
                      'assets/user.png',
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                          child: Text(
                            user.name ?? '',
                            style: requestTitle(),
                            textAlign: TextAlign.start,
                          ),
                        )),
                        // Text(
                        //   "2d",
                        //   style: notificationTime(),
                        //   textAlign: TextAlign.start,
                        // )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                          child: Text(
                            // item.sMutual
                            '1', style: notificationTime(),
                            textAlign: TextAlign.start,
                          ),
                        ))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: TextButton(
                          onPressed: () async {
                            await getIt<FirebaseCrud>().acceptFriendReq(
                              userController.loggedInUser!.id!,
                              user.id!,
                              userController.loggedInUser!,
                            );
                            await getAllUsers();
                            showToast('Friend Request Accepted');
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Confirm",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                )
                              ],
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff1773EA)),
                          ),
                        )),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: TextButton(
                                onPressed: () {},
                                child: Text("Delete",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14)),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xffdcdcdc)),
                                )))
                      ],
                    )
                  ],
                )),
              ],
            ),
            //Row(children: [Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text(item.nBody, style: AppTheme.nbodyText, textAlign: TextAlign.start,),))],)
          ],
        ),
      ),
    );
  }

  Widget myFriendWidget(UserModel user) {
    return Card(
      margin: const EdgeInsets.fromLTRB(2, 1, 2, 1),
      elevation: 0.0,
      color: ThemeColors.blueNotification,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (user.image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(80.0),
                    child: Image.network(
                      user.image!,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  ClipRRect(
                    borderRadius: BorderRadius.circular(80.0),
                    child: Image.asset(
                      'assets/user.png',
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 25, 0, 2),
                          child: Text(
                            user.name ?? '',
                            style: requestTitle(),
                            textAlign: TextAlign.start,
                          ),
                        )),
                        // Text(
                        //   "2d",
                        //   style: notificationTime(),
                        //   textAlign: TextAlign.start,
                        // )
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //         child: Padding(
                    //       padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                    //       child: Text(
                    //         // item.sMutual
                    //         '1', style: notificationTime(),
                    //         textAlign: TextAlign.start,
                    //       ),
                    //     ))
                    //   ],
                    // ),

                  ],
                )),
              ],
            ),
            //Row(children: [Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(0, 8, 0, 8), child: Text(item.nBody, style: AppTheme.nbodyText, textAlign: TextAlign.start,),))],)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Padding(
            //   padding: EdgeInsets.all(10),
            //   child: Row(
            //     children: [
            //       TextButton(
            //           onPressed: () {},
            //           child: Text("Suggestions",
            //               style: TextStyle(color: Colors.black, fontSize: 14)),
            //           style: ButtonStyle(
            //             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //                 RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(20.0),
            //               // side: BorderSide(color: Colors.black)
            //             )),
            //             backgroundColor:
            //                 MaterialStateProperty.all(const Color(0xffdcdcdc)),
            //           )),
            //       SizedBox(
            //         width: 10,
            //       ),
            //       TextButton(
            //           onPressed: () {},
            //           child: Text("Your Friends",
            //               style: TextStyle(color: Colors.black, fontSize: 14)),
            //           style: ButtonStyle(
            //             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //                 RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(20.0),
            //               // side: BorderSide(color: Colors.black)
            //             )),
            //             backgroundColor:
            //                 MaterialStateProperty.all(const Color(0xffdcdcdc)),
            //           ))
            //     ],
            //   ),
            // ),
            if (myFriends.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      "My Friend (${myFriends.length})",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
              ),
            if (myFriends.isNotEmpty)
              ListView.builder(
                  itemCount: myFriends.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = myFriends[index];
                    return myFriendWidget(item);
                    // return addFriendWidget(item);
                  }),
            if (incomingReqUsers.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Friend Requests (${incomingReqUsers.length})",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
              ),
            if (incomingReqUsers.isNotEmpty)
              ListView.builder(
                  itemCount: incomingReqUsers.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = incomingReqUsers[index];
                    return friendReqWidget(item);
                    // return addFriendWidget(item);
                  }),
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    "Suggestions",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  )),
                ],
              ),
            ),
            ListView.builder(
                itemCount: unknownUsers.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = unknownUsers[index];
                  // return friendReqWidget(item);
                  return addFriendWidget(item);
                })
          ],
        ),
      ),
    );
  }
}
