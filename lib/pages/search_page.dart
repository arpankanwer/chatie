import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/services/database_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isLoading = false;
  TextEditingController groupSearch = TextEditingController();
  QuerySnapshot? groups;
  bool hasUserSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Search"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: groupSearch,
                    decoration: const InputDecoration(
                      hintText: "Search Groups",
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      getGroups();
                    },
                    icon: const Icon(Icons.search))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : groupList(),
          )
        ],
      ),
    );
  }

  getGroups() async {
    if (groupSearch.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService().getGroupsByName(groupSearch.text).then((value) {
        setState(() {
          hasUserSearch = true;
          groups = value;
          isLoading = false;
        });
      });
    }
    return const Text("Enter to find groups");
  }

  groupList() {
    return hasUserSearch
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: groups!.docs.length,
            itemBuilder: (context, index) {},
          )
        : Container();
  }
}
