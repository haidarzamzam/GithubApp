import 'package:flutter/material.dart';
import 'package:github_app/screens/menus/search_issues_screen.dart';
import 'package:github_app/screens/menus/search_repositories_screen.dart';
import 'package:github_app/screens/menus/search_users_screen.dart';
import 'package:github_app/utils/toast.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int indexTab = 0;
  String search = "doraemon";
  String labelSearch = "Search Users. . .";
  final searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      height: 40,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: searchTextController,
                        autocorrect: true,
                        onSubmitted: (value) {
                          if (value.toString() == "") {
                            ToastUtils.show("Please fill the entry");
                          } else {
                            search = value.toString();
                          }
                        },
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: labelSearch,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.blue,
                          ),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Icon(Icons.tune, color: Colors.blue),
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: new Size(double.infinity, 50.0),
            child: Container(
              height: 50.0,
              padding: EdgeInsets.only(bottom: 4.0),
              child: TabBar(
                  labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  isScrollable: false,
                  labelStyle:
                      TextStyle(fontSize: 16.0, fontFamily: 'Montserrat'),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.white,
                  onTap: (index) {
                    if (index == 0) {
                      setState(() {
                        labelSearch = "Search Users. . .";
                        indexTab = index;
                      });
                    } else if (index == 1) {
                      setState(() {
                        labelSearch = "Search Issues. . .";
                        indexTab = index;
                      });
                    } else if (index == 2) {
                      setState(() {
                        labelSearch = "Search Repository. . .";
                        indexTab = index;
                      });
                    }
                  },
                  tabs: [
                    Tab(
                      child: Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 12.0),
                            child: FittedBox(child: Text("Users")),
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 12.0),
                            child: FittedBox(child: Text("Issues")),
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 12.0),
                            child: FittedBox(child: Text("Repositories")),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
        body: TabBarView(physics: NeverScrollableScrollPhysics(), children: [
          SearchUsersScreen(),
          SearchIssuesScreen(),
          SearchRepositoryScreen(),
        ]),
      ),
    );
  }
}
