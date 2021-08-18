import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:links/constants/blog_post.dart';
import 'package:links/constants/event.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/constants/group.dart';
import 'package:links/constants/level_types.dart';
import 'package:links/constants/message.dart';
import 'package:links/constants/request.dart';
import 'package:links/constants/tag.dart';
import 'package:links/constants/user_data_save.dart';
import 'package:links/constants/notification.dart';

class DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference events = FirebaseFirestore.instance.collection('events');
  CollectionReference groups = FirebaseFirestore.instance.collection('groups');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference groupChats =
      FirebaseFirestore.instance.collection('groupchats');
  CollectionReference tags = FirebaseFirestore.instance.collection('tags');

  User user = FirebaseAuth.instance.currentUser;

  Future<String> addEvent(Event event) async {
    // Call the user's CollectionReference to add a new user
    return await events.add(event.toMap()).then((value) {
      return value.id;
    }).catchError((error) {
      return null;
    });
  }

  Future<String> addEventToGroup(Event event, Group group) async {
    // Call the user's CollectionReference to add a new user
    return await groups
        .doc(group.docId)
        .collection('events')
        .add(event.toMap())
        .then((value) {
      return value.id;
    }).catchError((error) {
      return null;
    });
  }

  Future<String> addGroup(Group group) async {
    // Call the user's CollectionReference to add a new user
    return await groups.add(group.toMap()).then((value) {
      return value.id;
    }).catchError((error) {
      return null;
    });
  }

  Future<void> updateEvent(String id, Event event) {
    // Call the user's CollectionReference to add a new user
    return events
        .doc(id)
        .update(event.toMap())
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<bool> editEvent(String id, {title, description, tags}) {
    // Call the user's CollectionReference to add a new user
    return events
        .doc(id)
        .update({
          'title' : title,
          'description' : description,
          'tags' : tags
        })
        .then((value) => true)
        .catchError((error) {
          print(error);
          return false;
        });
  }

  Future<Event> getOneTimeEvent(String documentId) async {
    Event event = Event();
    DocumentSnapshot docOf = await events.doc(documentId).get();
    if(docOf.exists){
      event = Event.fromMap(docOf.data());
      event.docId = docOf.id;
      return event;
    }
    return null;
  }

  Stream<Event> getEventStream(Event event) {
    return events.doc(event.docId).snapshots().map((event) => Event.fromMap(event.data()));
  }

  Future<Event> getOneTimeGroupEvent(Group group, String documentId) async {
    Event event = Event();
    DocumentSnapshot docOf = await groups
        .doc(group.docId)
        .collection('events')
        .doc(documentId)
        .get();

    event = Event.fromMap(docOf.data());
    event.docId = docOf.id;
    return event;
  }

  Future<Group> getOneTimeGroup(String documentId) async {
    Group group = Group();
    DocumentSnapshot docOf = await groups.doc(documentId).get();

    group = Group.fromMap(docOf.data());
    group.docId = docOf.id;
    return group;
  }

  Future<String> joinEvent(Event event) async {
    String userId = user.uid;

    bool result = await events
        .doc(event.docId)
        .update({
          "usersIn": FieldValue.arrayUnion([userId])
        })
        .then((value) => true)
        .catchError((e) => false);

    if (result) {
      bool result = await users
          .doc(userId)
          .collection("preferences")
          .doc("preference save")
          .update({
            "myEventsJoined": FieldValue.arrayUnion([event.docId])
          })
          .then((value) => true)
          .catchError((e) => false);
      if (result) {
        return "Event joined";
      } else {
        return "Something went wrong";
      }
    } else {
      return "Something went wrong";
    }
  }

  Future<String> joinGroup(Group group) async {
    String userId = user.uid;

    bool result = await groups
        .doc(group.docId)
        .update({
          "usersIn": FieldValue.arrayUnion([userId])
        })
        .then((value) => true)
        .catchError((e) => false);

    if (result) {
      bool result = await users
          .doc(userId)
          .collection("preferences")
          .doc("preference save")
          .update({
            "groupsIn": FieldValue.arrayUnion([group.docId])
          })
          .then((value) => true)
          .catchError((e) => false);
      if (result) {
        return "Group joined";
      } else {
        return "Something went wrong";
      }
    } else {
      return "Something went wrong";
    }
  }

  Future<String> joinGroupEvent(Event event, Group group) async {
    String userId = user.uid;

    bool result = await groups
        .doc(group.docId)
        .collection('events')
        .doc(event.docId)
        .update({
          "usersIn": FieldValue.arrayUnion([userId])
        })
        .then((value) => true)
        .catchError((e) => false);

    if (result) {
      bool result = await users
          .doc(userId)
          .collection("preferences")
          .doc("preference save")
          .update({
            "myEventsJoined": FieldValue.arrayUnion([event.docId])
          })
          .then((value) => true)
          .catchError((e) => false);
      if (result) {
        return "Event joined";
      } else {
        return "Something went wrong";
      }
    } else {
      return "Something went wrong";
    }
  }

  Future<String> addToEvent(Event event, String userId) async {
    bool result = await events
        .doc(event.docId)
        .update({
          "usersIn": FieldValue.arrayUnion([userId])
        })
        .then((value) => true)
        .catchError((e) => false);

    await users
        .doc(userId)
        .collection("preferences")
        .doc("preference save")
        .update({
      "awaitingRequest": FieldValue.arrayRemove([event.docId])
    });

    if (result) {
      bool result = await users
          .doc(userId)
          .collection("preferences")
          .doc("preference save")
          .update({
            "myEventsJoined": FieldValue.arrayUnion([event.docId])
          })
          .then((value) => true)
          .catchError((e) => false);
      if (result) {
        return "Event joined";
      } else {
        return "Something went wrong";
      }
    } else {
      return "Something went wrong";
    }
  }

  Future<String> addToGroup(Group group, String userId) async {
    bool result = await groups
        .doc(group.docId)
        .update({
          "usersIn": FieldValue.arrayUnion([userId])
        })
        .then((value) => true)
        .catchError((e) => false);

    await users
        .doc(userId)
        .collection("preferences")
        .doc("preference save")
        .update({
      "awaitingGroupRequests": FieldValue.arrayRemove([group.docId])
    });

    if (result) {
      bool result = await users
          .doc(userId)
          .collection("preferences")
          .doc("preference save")
          .update({
            "groupsIn": FieldValue.arrayUnion([group.docId])
          })
          .then((value) => true)
          .catchError((e) => false);
      if (result) {
        return "Group joined";
      } else {
        return "Something went wrong";
      }
    } else {
      return "Something went wrong";
    }
  }

  Future<String> leaveEvent(String id, {bool eventExists = true}) async {
    String result = "";

    String userId = user.uid;
    result = await users
        .doc(userId)
        .collection("preferences")
        .doc("preference save")
        .update({
      "myEventsJoined": FieldValue.arrayRemove([id])
    }).then((value) {
      return "Left event successfully";
    }).catchError((onError) {
      return "Something went wrong";
    });

    if (eventExists) {
      print(id);
      events.doc(id).update({
        "usersIn": FieldValue.arrayRemove([userId])
      });
    }

    return result;
  }

  Future<String> leaveGroup(String id, {bool groupExists = true}) async {
    String result = "";

    String userId = user.uid;
    result = await users
        .doc(userId)
        .collection("preferences")
        .doc("preference save")
        .update({
      "groupsIn": FieldValue.arrayRemove([id])
    }).then((value) {
      return "Left group successfully";
    }).catchError((onError) {
      return "Something went wrong";
    });

    if (groupExists) {
      print(id);
      groups.doc(id).update({
        "usersIn": FieldValue.arrayRemove([userId])
      });
      groups.doc(id).collection('events').get().then((value) {
        for (DocumentSnapshot doc in value.docs) {
          doc.reference.update({
            "usersIn": FieldValue.arrayRemove([userId])
          });
        }
      });
    }

    return result;
  }

  Future<String> leaveEventInGroup(String id, Group group,
      {bool eventExists = true}) async {
    String result = "";

    String userId = user.uid;
    result = await users
        .doc(userId)
        .collection("preferences")
        .doc("preference save")
        .update({
      "myEventsJoined": FieldValue.arrayRemove([id])
    }).then((value) {
      return "Left event successfully";
    }).catchError((onError) {
      return "Something went wrong";
    });

    if (eventExists) {
      print(id);
      groups.doc(group.docId).collection('events').doc(id).update({
        "usersIn": FieldValue.arrayRemove([userId])
      });
    }

    return result;
  }

  Future<String> kickFromEvent({String userId, String eventId}) async {
    bool removedSuc = await users
        .doc(userId)
        .collection("preferences")
        .doc("preference save")
        .update({
      "myEventsJoined": FieldValue.arrayRemove([eventId])
    }).then((value) {
      return true;
    }).catchError((onError) {
      return false;
    });

    if (removedSuc) {
      return await events
          .doc(eventId)
          .update({
            "usersIn": FieldValue.arrayRemove([userId])
          })
          .then((value) => "User removed successfully")
          .catchError((e) => "Something went wrong");
    } else {
      return "Something went wrong";
    }
  }

  Future<String> kickFromGroup({String userId, String eventId}) async {
    bool removedSuc = await users
        .doc(userId)
        .collection("preferences")
        .doc("preference save")
        .update({
      "groupsIn": FieldValue.arrayRemove([eventId])
    }).then((value) {
      return true;
    }).catchError((onError) {
      return false;
    });

    if (removedSuc) {
      return await groups
          .doc(eventId)
          .update({
            "usersIn": FieldValue.arrayRemove([userId])
          })
          .then((value) => "User removed successfully")
          .catchError((e) => "Something went wrong");
    } else {
      return "Something went wrong";
    }
  }

  Future<List<Event>> getPublicEventsToDisplay(int limit,
      {DateTimeRange range}) async {
    if (range == null) {
      range = DateTimeRange(
          start: DateTime.now(),
          end: DateTime(DateTime.now().year + 1, DateTime.now().month,
              DateTime.now().day));
    }

    List<Event> eventsList = [];
    QuerySnapshot eventsOf = await events
        .where('private', isEqualTo: false)
        .where('dateStamp',
            isGreaterThanOrEqualTo: range.start.millisecondsSinceEpoch)
        .where('dateStamp',
            isLessThanOrEqualTo: range.end.millisecondsSinceEpoch)
        .limit(limit)
        .get();

    List<String> eventsAlreadyIn = [];
    eventsAlreadyIn = await getMyEventsIn().then((value) {
      List<String> events = [];
      for (Event event in value) {
        events.add(event.docId);
      }
      return events;
    });

    List<String> requestedEvents = [];
    List<String> notInterested = [];
    await getUserPreferences(user.uid).then((value) {
      if (value.awaitingRequest != null) {
        for (var item in value.awaitingRequest) {
          requestedEvents.add(item.toString());
        }
      }
      if (value.notInterested != null) {
        for (var item in value.notInterested) {
          notInterested.add(item.toString());
        }
      }
    });

    for (QueryDocumentSnapshot documentSnapshot in eventsOf.docs) {
      if (documentSnapshot.data()['owner'] != user.uid &&
          !eventsAlreadyIn.contains(documentSnapshot.id) &&
          !requestedEvents.contains(documentSnapshot.id) &&
          !notInterested.contains(documentSnapshot.id)) {
        Event cevent = Event.fromMap(documentSnapshot.data());
        cevent.docId = documentSnapshot.id;
        eventsList.add(cevent);
      }
    }
    print(eventsList.length);
    return eventsList;
  }

  Future<List<Group>> getPublicGroupsToDisplay(int limit) async {
    List<Group> groupsList = [];
    QuerySnapshot eventsOf =
        await groups.where('private', isEqualTo: false).limit(limit).get();

    List<String> groupsAlreadyIn = [];
    groupsAlreadyIn = await getMyGroupsIn().then((value) {
      List<String> groups = [];
      for (Group group in value) {
        groups.add(group.docId);
      }
      return groups;
    });

    List<String> requestedGroups = [];
    List<String> notInterested = [];
    await getUserPreferences(user.uid).then((value) {
      if (value.awaitingGroupRequests != null) {
        for (var item in value.awaitingGroupRequests) {
          requestedGroups.add(item.toString());
        }
      }
      if (value.notInterested != null) {
        for (var item in value.notInterested) {
          notInterested.add(item.toString());
        }
      }
    });

    for (QueryDocumentSnapshot documentSnapshot in eventsOf.docs) {
      if (documentSnapshot.data()['owner'] != user.uid &&
          !groupsAlreadyIn.contains(documentSnapshot.id) &&
          !requestedGroups.contains(documentSnapshot.id) &&
          !notInterested.contains(documentSnapshot.id)) {
        Group cgroup = Group.fromMap(documentSnapshot.data());
        cgroup.docId = documentSnapshot.id;
        groupsList.add(cgroup);
      }
    }
    return groupsList;
  }

  Future<List<Event>> getPublicEventsToDisplayLocationFiltered(
      int limit, GeoFirePoint center,
      {double radius = 50, DateTimeRange range}) async {
    if (range == null) {
      range = DateTimeRange(
          start: DateTime.now(),
          end: DateTime(DateTime.now().year + 1, DateTime.now().month,
              DateTime.now().day));
    }

    var geo = Geoflutterfire();

    Query eventsOf = events.where('private', isEqualTo: false).limit(limit);

    List<DocumentSnapshot> eventsReturned = await geo
        .collection(collectionRef: eventsOf)
        .within(
            center: center, radius: radius, field: 'position', strictMode: true)
        .first;

    List<Event> eventsList = [];

    List<String> eventsAlreadyIn = [];
    eventsAlreadyIn = await getMyEventsIn().then((value) {
      List<String> events = [];
      for (Event event in value) {
        events.add(event.docId);
      }
      return events;
    });

    List<String> requestedEvents = [];
    List<String> notInterested = [];
    await getUserPreferences(user.uid).then((value) {
      if (value.awaitingRequest != null) {
        for (var item in value.awaitingRequest) {
          requestedEvents.add(item.toString());
        }
      }
      if (value.notInterested != null) {
        for (var item in value.notInterested) {
          notInterested.add(item.toString());
        }
      }
    });

    for (QueryDocumentSnapshot documentSnapshot in eventsReturned) {
      if (documentSnapshot.data()['owner'] != user.uid &&
          !eventsAlreadyIn.contains(documentSnapshot.id) &&
          !requestedEvents.contains(documentSnapshot.id) &&
          !notInterested.contains(documentSnapshot.id) &&
          documentSnapshot.data()['dateStamp'] >=
              range.start.millisecondsSinceEpoch &&
          documentSnapshot.data()['dateStamp'] <=
              range.end.millisecondsSinceEpoch) {
        Event cevent = Event.fromMap(documentSnapshot.data());
        cevent.docId = documentSnapshot.id;
        eventsList.add(cevent);
      }
    }
    print(eventsList.length);
    return eventsList;
  }

  Future<List<Event>> getPrivateEventsToDisplay(int limit) async {
    List<Event> eventsList = [];
    QuerySnapshot eventsOf = await events
        .where('private', isEqualTo: true)
        .where('usersPermitted', arrayContains: user.uid)
        .limit(limit)
        .get();

    List<String> awaitingRequests = [];
    List<String> notInterested = [];
    await getUserPreferences(user.uid).then((value) {
      if (value.notInterested != null) {
        for (var item in value.notInterested) {
          notInterested.add(item.toString());
        }
      }
      if (value.awaitingRequest != null) {
        for (var item in value.awaitingRequest) {
          awaitingRequests.add(item.toString());
        }
      }
    });

    for (QueryDocumentSnapshot documentSnapshot in eventsOf.docs) {
      Event cevent = Event.fromMap(documentSnapshot.data());
      if ((cevent.usersIn == null || !cevent.usersIn.contains(user.uid)) &&
          !notInterested.contains(documentSnapshot.id) &&
          !awaitingRequests.contains(documentSnapshot.id)) {
        cevent.docId = documentSnapshot.id;
        eventsList.add(cevent);
      }
    }
    return eventsList;
  }

  Future<List<Group>> getPrivateGroupsToDisplay(int limit) async {
    List<Group> groupsList = [];
    QuerySnapshot eventsOf = await groups
        .where('private', isEqualTo: true)
        .where('usersPermitted', arrayContains: user.uid)
        .limit(limit)
        .get();

    List<String> awaitingRequests = [];
    List<String> notInterested = [];
    await getUserPreferences(user.uid).then((value) {
      if (value.notInterested != null) {
        for (var item in value.notInterested) {
          notInterested.add(item.toString());
        }
      }
      if (value.awaitingGroupRequests != null) {
        for (var item in value.awaitingGroupRequests) {
          awaitingRequests.add(item.toString());
        }
      }
    });

    for (QueryDocumentSnapshot documentSnapshot in eventsOf.docs) {
      Group cevent = Group.fromMap(documentSnapshot.data());
      if ((cevent.usersIn == null || !cevent.usersIn.contains(user.uid)) &&
          !notInterested.contains(documentSnapshot.id) &&
          !awaitingRequests.contains(documentSnapshot.id)) {
        cevent.docId = documentSnapshot.id;
        groupsList.add(cevent);
      }
    }
    return groupsList;
  }

  Future<List<Event>> getMyEventsIn() async {
    List<Event> eventsList = [];

    UserData userData = await getUserPreferences(user.uid);
    for (String id in userData.myEventsJoined) {
      await events.doc(id).get().then((value) {
        if (value.exists) {
          Event cevent = Event.fromMap(value.data());
          cevent.docId = value.id;
          eventsList.add(cevent);
        } else {
          leaveEvent(id, eventExists: false);
        }
      });
    }

    return eventsList;
  }

  Future<List<Group>> getMyGroupsIn() async {
    List<Group> groupsList = [];

    UserData userData = await getUserPreferences(user.uid);

    if (userData.groupsIn != null) {
      for (String id in userData.groupsIn) {
        await groups.doc(id).get().then((value) {
          if (value.exists) {
            Group cevent = Group.fromMap(value.data());
            cevent.docId = value.id;
            groupsList.add(cevent);
          } else {
            leaveGroup(id, groupExists: false);
          }
        });
      }
    }

    return groupsList;
  }

  Future<List<Event>> getMyEventsCreated() async {
    List<Event> eventsList = [];
    QuerySnapshot eventsOf =
        await events.where('owner', isEqualTo: user.uid).get();

    for (QueryDocumentSnapshot documentSnapshot in eventsOf.docs) {
      Event cevent = Event.fromMap(documentSnapshot.data());
      cevent.docId = documentSnapshot.id;
      eventsList.add(cevent);
    }
    return eventsList;
  }

  Future<List<Group>> getMyGroupsCreated() async {
    List<Group> groupsList = [];
    QuerySnapshot eventsOf =
        await groups.where('owner', isEqualTo: user.uid).get();

    for (QueryDocumentSnapshot documentSnapshot in eventsOf.docs) {
      Group cgroup = Group.fromMap(documentSnapshot.data());
      cgroup.docId = documentSnapshot.id;
      groupsList.add(cgroup);
    }
    return groupsList;
  }

  Future<List<Event>> getEventsInGroup(Group group) async {
    List<Event> eventsList = [];
    QuerySnapshot eventsOf =
        await groups.doc(group.docId).collection('events').get();

    List<String> requestedEvents = [];
    List<String> notInterested = [];
    await getUserPreferences(user.uid).then((value) {
      if (value.awaitingRequestGroupEvent != null) {
        for (var item in value.awaitingRequestGroupEvent) {
          requestedEvents.add(idsFromGERequest(item)['event']);
        }
      }
      if (value.notInterested != null) {
        for (var item in value.notInterested) {
          notInterested.add(item.toString());
        }
      }
    });

    print(requestedEvents);

    for (QueryDocumentSnapshot documentSnapshot in eventsOf.docs) {
      if (!requestedEvents.contains(documentSnapshot.id) &&
          !notInterested.contains(documentSnapshot.id)) {
        Event cevent = Event.fromMap(documentSnapshot.data());
        cevent.docId = documentSnapshot.id;
        eventsList.add(cevent);
      }
    }
    return eventsList;
  }

  Future<List<BlogPost>> getBlogPosts(Group group) async {
    List<BlogPost> blogsList = [];
    QuerySnapshot eventsOf =
        await groups.doc(group.docId).collection('blogs').get();

    for (QueryDocumentSnapshot documentSnapshot in eventsOf.docs) {
      BlogPost cevent = BlogPost.fromMap(documentSnapshot.data());
      cevent.docId = documentSnapshot.id;
      blogsList.add(cevent);
    }
    return blogsList;
  }

  Future<String> createBlogPost(Group group, BlogPost blogPost) async {
    return await groups
        .doc(group.docId)
        .collection('blogs')
        .add(blogPost.toMap())
        .then((value) {
      return 'Success';
    }).catchError((e) => "Something went wrong");
  }

  Future<String> deleteBlogPost(Group group, BlogPost blogPost) async {
    return await groups
        .doc(group.docId)
        .collection('blogs')
        .doc(blogPost.docId)
        .delete()
        .then((value) {
      return 'Deleted Successfully';
    }).catchError((e) => "Something went wrong");
  }

  Future<List<Event>> getUserEventsCreated(String id) async {
    List<String> eventsAlreadyIn = [];
    eventsAlreadyIn = await getMyEventsIn().then((value) {
      List<String> events = [];
      for (Event event in value) {
        events.add(event.docId);
      }
      return events;
    });

    List<String> notInterested = [];
    List<String> requestedEvents = [];
    await getUserPreferences(user.uid).then((value) {
      if (value.awaitingRequest != null) {
        for (var item in value.awaitingRequest) {
          requestedEvents.add(item.toString());
        }
      }
      if (value.notInterested != null) {
        for (var item in value.notInterested) {
          notInterested.add(item.toString());
        }
      }
    });

    List<Event> eventsList = [];
    QuerySnapshot eventsOf = await events
        .where('owner', isEqualTo: id)
        .where('private', isEqualTo: false)
        .get();

    for (QueryDocumentSnapshot documentSnapshot in eventsOf.docs) {
      if (documentSnapshot.data()['owner'] != user.uid &&
          !eventsAlreadyIn.contains(documentSnapshot.id) &&
          !requestedEvents.contains(documentSnapshot.id) &&
          !notInterested.contains(documentSnapshot.id)) {
        Event cevent = Event.fromMap(documentSnapshot.data());
        cevent.docId = documentSnapshot.id;
        eventsList.add(cevent);
      }
    }

    return eventsList;
  }

  void createUserPage(String email, String name, String uid) {
    users
        .doc(uid)
        .set({"email": email, 'name': name, 'bio': 'No bio yet'})
        .then((value) => updateUserPreferences(
            uid,
            UserData(
                awaitingGroupRequests: [],
                awaitingRequest: [],
                awaitingRequestGroupEvent: [],
                following: [],
                groupsIn: [],
                myEventsJoined: [],
                notInterested: [],
                subscribedTags: [])))
        .catchError((error) => print("Failed to add user: $error"));
  }

  void updateUserPreferences(String uid, UserData userData) {
    users
        .doc(uid)
        .collection("preferences")
        .doc("preference save")
        .set(userData.toMap())
        .then((value) => print("User Entry Added"))
        .catchError((error) => print("Failed to add user: $error"));

    users
        .doc(uid)
        .collection("level")
        .doc("level")
        .set({'level' : AccountLevels.BASIC})
        .then((value) => print("User Entry Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<UserData> getUserPreferences(String uid) async {
    DocumentSnapshot userPage = await users
        .doc(uid)
        .collection("preferences")
        .doc("preference save")
        .get();

    return UserData.fromMap(userPage.data());
  }

  Future<Map> getUser(String uid) async {
    DocumentSnapshot doc = await users.doc(uid).get();
    return doc.data();
  }

  Future<List<FriendData>> getUserFriends(String uid) async {
    return await users
        .doc(uid)
        .collection("preferences")
        .doc("preference save")
        .get()
        .then((snapshot) async {
      List<FriendData> userDatas = [];

      UserData thisUserData = UserData.fromMap(snapshot.data());
      List userIds = thisUserData.following;

      for (String id in userIds) {
        Map friendData = await getUser(id);
        friendData["userId"] = id;
        userDatas.add(FriendData.fromMap(friendData));
      }

      return userDatas;
    }).catchError((e) {
      print(e);
      return [null];
    });
  }

  Future<String> addFriend(String id) async {
    return await users
        .doc(user.uid)
        .collection("preferences")
        .doc("preference save")
        .update({
          'following': FieldValue.arrayUnion([id])
        })
        .then((value) => "Added friend")
        .catchError((e) => "Something went wrong");
  }

  Future<String> removeFriend(String id) async {
    return await users
        .doc(user.uid)
        .collection("preferences")
        .doc("preference save")
        .update({
          'following': FieldValue.arrayRemove([id])
        })
        .then((value) => "Removed friend")
        .catchError((e) => "Something went wrong");
  }

  Future<FriendData> searchFriendsEmail(String email) async {
    List<FriendData> friends = await getUserFriends(user.uid);
    List<String> idsAlready = [];
    for (FriendData friend in friends) {
      idsAlready.add(friend.userId);
    }

    return await users
        .where("email", isEqualTo: email)
        .limit(1)
        .get()
        .then((value) {
      if (value.docs.length > 0 &&
          value.docs[0].id != user.uid &&
          !idsAlready.contains(value.docs[0].id)) {
        FriendData friend = FriendData.fromMap(value.docs[0].data());
        friend.userId = value.docs[0].id;
        return friend;
      } else {
        return null;
      }
    });
  }

  Future<String> editNameAndBio(String name, String bio) async {
    String result = await users
        .doc(user.uid)
        .update({'name': name, 'bio': bio})
        .then((v) => "Name and bio updated")
        .catchError((e) => "Something went wrong");
    return result;
  }

  Future<List<FriendData>> searchFriendsName(String name) async {
    List<FriendData> friends = await getUserFriends(user.uid);
    List<String> idsAlready = [];
    for (FriendData friend in friends) {
      idsAlready.add(friend.userId);
    }

    return await users
        .where("name", isGreaterThanOrEqualTo: name)
        .where("name", isLessThan: name + 'z')
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        List<FriendData> friends = [];
        for (DocumentSnapshot documentSnapshot in value.docs) {
          if (documentSnapshot.id != user.uid &&
              !idsAlready.contains(documentSnapshot.id)) {
            FriendData friend = FriendData.fromMap(documentSnapshot.data());
            friend.userId = documentSnapshot.id;
            friends.add(friend);
          }
        }
        return friends;
      } else {
        return null;
      }
    });
  }

  Future<String> createGroupChat(String uid) async {
    return await groupChats.add({"owner": uid}).then((value) {
      return value.id;
    });
  }

  void deleteGroupChat(String id) async {
    if (id != null) {
      batchDelete(groupChats.doc(id).collection("messages"));

      groupChats.doc(id).delete();
    }
  }

  Future<String> deleteEvent(Event event) async {
    batchDelete(events.doc(event.docId).collection("messages"));
    batchDelete(events.doc(event.docId).collection("requests"));
    deleteGroupChat(event.groupChatEnabledID);
    return await events
        .doc(event.docId)
        .delete()
        .then((value) => "Deleted successfully")
        .catchError((e) => "Something went wrong");
  }

  Future<String> deleteGroup(Group group) async {
    batchDelete(groups.doc(group.docId).collection("events"));
    batchDelete(events.doc(group.docId).collection("blogs"));
    deleteGroupChat(group.groupchatId);
    return await groups
        .doc(group.docId)
        .delete()
        .then((value) => "Deleted successfully")
        .catchError((e) => "Something went wrong");
  }

  Future<String> deleteEventInGroup(Event event, Group group) async {
    batchDelete(groups
        .doc(group.docId)
        .collection('events')
        .doc(event.docId)
        .collection("messages"));
    batchDelete(groups
        .doc(group.docId)
        .collection('events')
        .doc(event.docId)
        .collection("requests"));
    deleteGroupChat(event.groupChatEnabledID);
    return await groups
        .doc(group.docId)
        .collection('events')
        .doc(event.docId)
        .delete()
        .then((value) => "Deleted successfully")
        .catchError((e) => "Something went wrong");
  }

  Future<List<FriendData>> getUsersInGroup(Event event) async {
    List<FriendData> usersInReturn = [];
    if (event.usersIn == null) {
      return usersInReturn;
    }
    for (var userId in event.usersIn) {
      Map friendData = await getUser(userId);
      friendData["userId"] = userId;
      if (userId != user.uid) {
        usersInReturn.add(FriendData.fromMap(friendData));
      }
    }
    if (event.owner != user.uid) {
      Map friendData = await getUser(event.owner);
      friendData["userId"] = event.owner;
      usersInReturn.add(FriendData.fromMap(friendData));
    }
    return usersInReturn;
  }

  Future<List<FriendData>> getUsersInGroupp(Group group) async {
    List<FriendData> usersInReturn = [];
    print(group.toMap());
    if (group.usersIn == null || group.usersIn.length == 0) {
      return [];
    }
    for (var userId in group.usersIn) {
      Map friendData = await getUser(userId);
      friendData["userId"] = userId;
      if (userId != user.uid) {
        usersInReturn.add(FriendData.fromMap(friendData));
      }
    }
    if (group.owner != user.uid) {
      Map friendData = await getUser(group.owner);
      friendData["userId"] = group.owner;
      usersInReturn.add(FriendData.fromMap(friendData));
    }
    return usersInReturn;
  }

  Stream streamGroupchat(String id) {
    Stream<QuerySnapshot> stream = groupChats
        .doc(id)
        .collection("messages")
        .orderBy('timeStamp', descending: true)
        .limit(50)
        .snapshots();

    return stream;
  }

  Future<bool> sendMessageToGroupChat(
      {Message message, String groupchatId}) async {
    return await groupChats
        .doc(groupchatId)
        .collection("messages")
        .add(message.toMap())
        .then((value) => true)
        .catchError((e) => false);
  }

  ensureDocExists({Event event, String to}) {
    events
        .doc(event.docId)
        .collection("messages")
        .doc(to == null ? user.uid : to)
        .get()
        .then((value) {
      if (!value.exists) {
        events
            .doc(event.docId)
            .collection("messages")
            .doc(to == null ? user.uid : to)
            .set({'non-null': true});
      }
    });
  }

  Future<bool> sendMessageToFromOwner(
      {Message message, Event event, String to}) async {
    return await events
        .doc(event.docId)
        .collection("messages")
        .doc(to == null ? user.uid : to)
        .collection("message_stream")
        .add(message.toMap())
        .then((value) => true)
        .catchError((onError) => false);
  }

  Stream streamMessagesWithOwner(Event event, {String from}) {
    Stream<QuerySnapshot> stream = events
        .doc(event.docId)
        .collection("messages")
        .doc(from == null ? user.uid : from)
        .collection("message_stream")
        .orderBy('timeStamp', descending: true)
        .limit(25)
        .snapshots();

    return stream;
  }

  Future<List<FriendData>> getOwnerInbox(Event event) async {
    List userMessages = [];
    List<FriendData> friends = [];

    QuerySnapshot snapshotOfDocs =
        await events.doc(event.docId.trim()).collection("messages").get();

    for (DocumentSnapshot documentSnapshot in snapshotOfDocs.docs) {
      userMessages.add(documentSnapshot.id);
    }

    for (String id in userMessages) {
      FriendData data = FriendData.fromMap(await getUser(id));
      data.userId = id;
      friends.add(data);
    }

    return friends;
  }

  Future<String> notInterested(Event event) async {
    return await users
        .doc(user.uid)
        .collection("preferences")
        .doc("preference save")
        .update({
          "notInterested": FieldValue.arrayUnion([event.docId])
        })
        .then((v) => "Event hidden")
        .catchError((onError) => "Something went wrong");
  }

  Future<String> notInterestedInGroup(Group group) async {
    return await users
        .doc(user.uid)
        .collection("preferences")
        .doc("preference save")
        .update({
          "notInterested": FieldValue.arrayUnion([group.docId])
        })
        .then((v) => "Group hidden")
        .catchError((onError) => "Something went wrong");
  }

  Future<String> requestToJoin(Event event, Request request) async {
    await users
        .doc(user.uid)
        .collection("preferences")
        .doc("preference save")
        .update({
      "awaitingRequest": FieldValue.arrayUnion([event.docId])
    });

    return await events
        .doc(event.docId)
        .collection("requests")
        .add(request.toMap())
        .then((value) => "Request sent")
        .catchError((onError) => "Something went wrong");
  }

  Future<String> requestToJoinGroup(Group group, Request request) async {
    await users
        .doc(user.uid)
        .collection("preferences")
        .doc("preference save")
        .update({
      "awaitingGroupRequests": FieldValue.arrayUnion([group.docId])
    });

    return await groups
        .doc(group.docId)
        .collection("requests")
        .add(request.toMap())
        .then((value) => "Request sent")
        .catchError((onError) => "Something went wrong");
  }

  Future<String> requestToJoinGroupEvent(
      Event event, Request request, Group group) async {
    await users
        .doc(user.uid)
        .collection("preferences")
        .doc("preference save")
        .update({
      "awaitingRequestGroupEvent":
          FieldValue.arrayUnion(['${event.docId}/${group.docId}'])
    });

    return await groups
        .doc(group.docId)
        .collection('events')
        .doc(event.docId)
        .collection("requests")
        .add(request.toMap())
        .then((value) => "Request sent")
        .catchError((onError) => "Something went wrong");
  }

  Future<List<Request>> getRequests(Event event) async {
    List<Request> requests = [];
    QuerySnapshot snapshot = await events
        .doc(event.docId)
        .collection("requests")
        .where("decision", isEqualTo: Request.PENDING)
        .get();

    for (DocumentSnapshot doc in snapshot.docs) {
      Request request = Request.fromMap(doc.data());
      request.docId = doc.id;
      requests.add(request);
    }
    return requests;
  }

  Future<List<Request>> getGroupRequests(Group group) async {
    List<Request> requests = [];
    QuerySnapshot snapshot = await groups
        .doc(group.docId)
        .collection("requests")
        .where("decision", isEqualTo: Request.PENDING)
        .get();

    for (DocumentSnapshot doc in snapshot.docs) {
      Request request = Request.fromMap(doc.data());
      request.docId = doc.id;
      requests.add(request);
    }
    return requests;
  }

  Future<List<Event>> hasRequestsPending() async {
    List<Event> eventsOwned = [];
    eventsOwned = await getMyEventsCreated();

    List<Event> eventsWithRequests = [];
    for (Event event in eventsOwned) {
      List<Request> requests = await getRequests(event);
      if (requests.length > 0) {
        eventsWithRequests.add(event);
      }
    }

    return eventsWithRequests;
  }

  Future<List<Request>> getRequestsPending() async {
    List<Request> requests = [];
    UserData me = await getUserPreferences(user.uid);

    for (String eventId in me.awaitingRequest) {
      Event event = await getOneTimeEvent(eventId);
      if(event == null){
        clearRequest(eventId);
        continue;
      }
      QuerySnapshot snapshot = await events
          .doc(event.docId)
          .collection("requests")
          .where("userId", isEqualTo: user.uid)
          .get();
      Request request = Request.fromMap(snapshot.docs[0].data());
      request.docId = snapshot.docs[0].id;
      request.eventAttached = event;
      requests.add(request);
    }

    return requests;
  }

  Future<List<Request>> getRequestsGEPending(Group group) async {
    List<Request> requests = [];
    UserData me = await getUserPreferences(user.uid);

    if (me.awaitingRequestGroupEvent == null) {
      return requests;
    }

    for (String stringVal in me.awaitingRequestGroupEvent) {
      String groupId = idsFromGERequest(stringVal)['group'];
      String eventId = idsFromGERequest(stringVal)['event'];
      if (groupId == group.docId) {
        Event event = await getOneTimeGroupEvent(group, eventId);
        QuerySnapshot snapshot = await groups
            .doc(group.docId)
            .collection("events")
            .doc(eventId)
            .collection('requests')
            .where("userId", isEqualTo: user.uid)
            .get();
        Request request = Request.fromMap(snapshot.docs[0].data());
        request.docId = snapshot.docs[0].id;
        request.eventAttached = event;
        request.groupAttached = group;
        requests.add(request);
      }
    }

    return requests;
  }

  Future<List<Request>> getRequestsPendingGroups() async {
    List<Request> requests = [];
    UserData me = await getUserPreferences(user.uid);

    if (me.awaitingGroupRequests != null) {
      for (String groupId in me.awaitingGroupRequests) {
        Group group = await getOneTimeGroup(groupId);
        QuerySnapshot snapshot = await groups
            .doc(group.docId)
            .collection("requests")
            .where("userId", isEqualTo: user.uid)
            .get();
        Request request = Request.fromMap(snapshot.docs[0].data());
        request.docId = snapshot.docs[0].id;
        request.groupAttached = group;
        requests.add(request);
      }
    }

    return requests;
  }

  Future<String> denyRequestStatus(Event event, Request request) async {
    return await events
        .doc(event.docId)
        .collection("requests")
        .doc(request.docId)
        .update({"decision": Request.DECLINED})
        .then((value) => "Request denied")
        .catchError((onError) => "Something went wrong");
  }

  Future<String> denyRequestStatusGroup(Group group, Request request) async {
    return await groups
        .doc(group.docId)
        .collection("requests")
        .doc(request.docId)
        .update({"decision": Request.DECLINED})
        .then((value) => "Request denied")
        .catchError((onError) => "Something went wrong");
  }

  Future<String> clearRequest(String id) async {
    return await users
        .doc(user.uid)
        .collection("preferences")
        .doc("preference save")
        .update({
      "awaitingRequest":
      FieldValue.arrayRemove([id])
    })
        .then((value) => "Success")
        .catchError((e) => "Something went wrong");
  }

  Future<String> agknoledgeRequestDecision(Request request) async {
    await events
        .doc(request.eventAttached.docId)
        .collection("requests")
        .doc(request.docId)
        .delete();

    return await users
        .doc(request.userId)
        .collection("preferences")
        .doc("preference save")
        .update({
          "awaitingRequest":
              FieldValue.arrayRemove([request.eventAttached.docId])
        })
        .then((value) => "Success")
        .catchError((e) => "Something went wrong");
  }

  Future<String> agknoledgeRequestDecisionGE(Request request) async {
    await groups
        .doc(request.groupAttached.docId)
        .collection("events")
        .doc(request.eventAttached.docId)
        .collection('requests')
        .doc(request.docId)
        .delete();

    return await users
        .doc(request.userId)
        .collection("preferences")
        .doc("preference save")
        .update({
          "awaitingRequestGroupEvent": FieldValue.arrayRemove(
              ['${request.eventAttached.docId}/${request.groupAttached.docId}'])
        })
        .then((value) => "Success")
        .catchError((e) => "Something went wrong");
  }

  Future<String> agknoledgeRequestDecisionGroup(Request request) async {
    await groups
        .doc(request.groupAttached.docId)
        .collection("requests")
        .doc(request.docId)
        .delete();

    return await users
        .doc(request.userId)
        .collection("preferences")
        .doc("preference save")
        .update({
          "awaitingGroupRequests":
              FieldValue.arrayRemove([request.groupAttached.docId])
        })
        .then((value) => "Success")
        .catchError((e) => "Something went wrong");
  }

  Future<String> allowRequestStatus(Event event, Request request) async {
    events.doc(event.docId).collection("requests").doc(request.docId).delete();

    await users
        .doc(request.userId)
        .collection("preferences")
        .doc("preference save")
        .update({
      "awaitingRequest": FieldValue.arrayRemove([event.docId])
    });

    return await addToEvent(event, request.userId);
  }

  Future<String> allowRequestStatusGroup(Group group, Request request) async {
    groups.doc(group.docId).collection("requests").doc(request.docId).delete();

    await users
        .doc(request.userId)
        .collection("preferences")
        .doc("preference save")
        .update({
      "awaitingGroupRequests": FieldValue.arrayRemove([group.docId])
    });

    return await addToGroup(group, request.userId);
  }

  Future<void> batchDelete(CollectionReference collectionReference) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    return collectionReference.get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.delete(document.reference);
      });

      return batch.commit();
    });
  }

  Stream<List<NotificationData>> streamNotifications() {
    return users
        .doc(user.uid)
        .collection('notifications')
        .snapshots()
        .map((data) {
      List<NotificationData> notifs = [];
      for (DocumentSnapshot documentSnapshot in data.docs) {
        NotificationData notification =
            NotificationData.fromMap(documentSnapshot.data());
        notification.id = documentSnapshot.id;
        notifs.add(notification);
      }
      return notifs;
    });
  }

  Future<String> deleteNotification(NotificationData notif) async {
    return await users
        .doc(user.uid)
        .collection('notifications')
        .doc(notif.id)
        .delete()
        .then((value) => "Notification Dismissed")
        .catchError((e) => "Something went wrong");
  }

  Future<int> amountOfNotifs() async {
    return await users
        .doc(user.uid)
        .collection('notifications')
        .get()
        .then((value) => value.docs.length)
        .catchError((e) => 0);
  }

  Future<List<String>> getTagsSubbed() async {
    UserData userData = await getUserPreferences(user.uid);
    List<String> tags = [];
    if(userData.subscribedTags!=null){
      for (var item in userData.subscribedTags) {
        tags.add(item.toString());
      }
    }
    return tags;
  }

  Future<bool> subToTag(Tag tag) async {
    return await users
        .doc(user.uid)
        .collection("preferences")
        .doc("preference save")
        .update({
          'subscribedTags': FieldValue.arrayUnion([tag.name])
        })
        .then((value) => true)
        .catchError((onError) => false);
  }

  Future<bool> unSubFromTag(Tag tag) async {
    return await users
        .doc(user.uid)
        .collection("preferences")
        .doc("preference save")
        .update({
          'subscribedTags': FieldValue.arrayRemove([tag.name])
        })
        .then((value) => true)
        .catchError((onError) => false);
  }

  Future<List<Tag>> getTags() async {
    return await tags.get().then((value) {
      List<Tag> tags = [];
      for (DocumentSnapshot doc in value.docs) {
        Tag tag = Tag.fromMap(doc.data());
        tag.id = doc.id;
        tags.add(tag);
      }
      return tags;
    });
  }

  Map idsFromGERequest(String string) {
    int idx = string.indexOf("/");
    List parts = [
      string.substring(0, idx).trim(),
      string.substring(idx + 1).trim()
    ];
    return {'event': parts[0], 'group': parts[1]};
  }

  Future calculateAmountOwed() async {
    var amountOwed = 0.0;
    await firestore.collection('payments')
        .where('paymentRecipient', isEqualTo: user.uid)
        .where('payedOut', isEqualTo: false)
        .where('locked', isEqualTo: false)
        .get()
        .then((value) {
           for(QueryDocumentSnapshot doc in value.docs){
             amountOwed += double.parse(doc.data()['amount']);
           }
         })
        .catchError((e){
          print(e);
        });

    return double.parse((amountOwed * 0.92).toStringAsFixed(2));
  }

  Future<AccountLevels> getAccountLevel() async {
    if(user == null){
      return AccountLevels.BASIC;
    }
    var data = await users.doc(user.uid).collection('level').doc('level').get();
    if(data.exists){
      AccountLevels level = AccountLevels.values[data.data()['level']];
      return level;
    }
    return AccountLevels.BASIC;
  }

}
