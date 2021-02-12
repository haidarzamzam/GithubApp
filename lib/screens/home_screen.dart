import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_app/app.dart';
import 'package:github_app/blocs/search/bloc.dart';
import 'package:github_app/screens/menus/search_issues_screen.dart';
import 'package:github_app/screens/menus/search_repositories_screen.dart';
import 'package:github_app/screens/menus/search_users_screen.dart';
import 'package:github_app/utils/constants.dart';
import 'package:github_app/utils/toast.dart';
import 'package:github_app/utils/tools.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SearchBloc _searchBloc;
  bool _isLoading = true;
  int indexTab = 0;
  String search = "doraemon";
  String labelSearch = "Search Users. . .";
  final searchTextController = TextEditingController(text: "doraemon");

  @override
  void initState() {
    super.initState();
    _searchBloc = BlocProvider.of<SearchBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _searchBloc,
      listener: (context, state) {
        if (state is DoGetDataState) {
          _isLoading = state.isLoading;
        }
      },
      child: BlocBuilder(
          bloc: _searchBloc,
          builder: (context, state) {
            return LoadingOverlay(
              isLoading: _isLoading,
              child: DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: HexColor(Settings['MainColor']),
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
                                      if (indexTab == 0) {
                                        _searchBloc.add(
                                            DoGetDataEvent(isLoading: true));
                                        _searchBloc.add(GetSearchUsersEvent(
                                            q: search, perPage: "10", page: 1));
                                      } else if (indexTab == 1) {
                                        _searchBloc.add(
                                            DoGetDataEvent(isLoading: true));
                                        _searchBloc.add(GetSearchIssuesEvent(
                                            q: search, perPage: "10", page: 1));
                                      } else if (indexTab == 2) {
                                        _searchBloc.add(
                                            DoGetDataEvent(isLoading: true));
                                        _searchBloc.add(
                                            GetSearchRepositoriesEvent(
                                                q: search,
                                                perPage: "10",
                                                page: 1));
                                      }
                                    }
                                  },
                                  textInputAction: TextInputAction.search,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: labelSearch,
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: HexColor(Settings['MainColor']),
                                    ),
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showModalBottomSheet(indexTab);
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Icon(Icons.tune,
                                color: HexColor(Settings['MainColor'])),
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
                            labelStyle: TextStyle(
                                fontSize: 16.0, fontFamily: 'Montserrat'),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: FittedBox(
                                          child: Text("Repositories")),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  body: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        SearchUsersScreen(),
                        SearchIssuesScreen(),
                        SearchRepositoryScreen(),
                      ]),
                ),
              ),
            );
          }),
    );
  }

  void _showModalBottomSheet(int indexTab) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SettingsTypeSort(indexTab: indexTab);
        });
  }
}

class SettingsTypeSort extends StatefulWidget {
  final int indexTab;

  const SettingsTypeSort({Key key, this.indexTab}) : super(key: key);

  @override
  _SettingsTypeSortState createState() => _SettingsTypeSortState();
}

class _SettingsTypeSortState extends State<SettingsTypeSort> {
  SearchBloc _searchBloc;
  SharedPreferences _prefs = App().sharedPreferences;
  int _radioValueTypeSort = 0;

  void _handleRadioValueChangeSort(int value) {
    setState(() {
      _radioValueTypeSort = value;

      switch (_radioValueTypeSort) {
        case 0:
          _radioValueTypeSort = 0;
          break;
        case 1:
          _radioValueTypeSort = 1;
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _searchBloc = BlocProvider.of<SearchBloc>(context);
    if (widget.indexTab == 0) {
      if (_prefs.getString(ConstansString.TYPE_SORT_USERS) == "loading") {
        _radioValueTypeSort = 0;
      } else if (_prefs.getString(ConstansString.TYPE_SORT_USERS) == "index") {
        _radioValueTypeSort = 1;
      }
    } else if (widget.indexTab == 1) {
      if (_prefs.getString(ConstansString.TYPE_SORT_ISSUES) == "loading") {
        _radioValueTypeSort = 0;
      } else if (_prefs.getString(ConstansString.TYPE_SORT_ISSUES) == "index") {
        _radioValueTypeSort = 1;
      }
    }
    if (widget.indexTab == 2) {
      if (_prefs.getString(ConstansString.TYPE_SORT_REPOSITORIES) ==
          "loading") {
        _radioValueTypeSort = 0;
      } else if (_prefs.getString(ConstansString.TYPE_SORT_REPOSITORIES) ==
          "index") {
        _radioValueTypeSort = 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: MediaQuery.of(context).size.height * 0.35,
        color: Color(0xFF737373),
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
              ),
            ),
            child: Container(
                padding: MediaQuery
                    .of(context)
                    .viewInsets,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new ListView(children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.clear,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: size.width * 0.02),
                          Text(
                            "Choose type short",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      Column(
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: 0,
                                groupValue: _radioValueTypeSort,
                                onChanged: _handleRadioValueChangeSort,
                              ),
                              Text(
                                'Lazy loading',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 1,
                                groupValue: _radioValueTypeSort,
                                onChanged: _handleRadioValueChangeSort,
                              ),
                              Text(
                                'With index',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),
                      Container(
                        width: size.width,
                        height: size.height * 0.06,
                        child: RaisedButton(
                            color: HexColor(Settings['MainColor']),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Apply',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            onPressed: () {
                              if (_radioValueTypeSort == 0) {
                                if (widget.indexTab == 0) {
                                  _searchBloc.add(DoSwitchSortEvent(
                                      type: "loading", api: "users"));
                                  _prefs.setString(
                                      ConstansString.TYPE_SORT_USERS,
                                      "loading");
                                } else if (widget.indexTab == 1) {
                                  _searchBloc.add(DoSwitchSortEvent(
                                      type: "loading", api: "issues"));
                                  _prefs.setString(
                                      ConstansString.TYPE_SORT_ISSUES,
                                      "loading");
                                } else if (widget.indexTab == 2) {
                                  _searchBloc.add(DoSwitchSortEvent(
                                      type: "loading", api: "repositories"));
                                  _prefs.setString(
                                      ConstansString.TYPE_SORT_REPOSITORIES,
                                      "loading");
                                }
                              } else if (_radioValueTypeSort == 1) {
                                if (widget.indexTab == 0) {
                                  _searchBloc.add(DoSwitchSortEvent(
                                      type: "index", api: "users"));
                                  _prefs.setString(
                                      ConstansString.TYPE_SORT_USERS, "index");
                                } else if (widget.indexTab == 1) {
                                  _searchBloc.add(DoSwitchSortEvent(
                                      type: "index", api: "issues"));
                                  _prefs.setString(
                                      ConstansString.TYPE_SORT_ISSUES, "index");
                                } else if (widget.indexTab == 2) {
                                  _searchBloc.add(DoSwitchSortEvent(
                                      type: "index", api: "repositories"));
                                  _prefs.setString(
                                      ConstansString.TYPE_SORT_REPOSITORIES,
                                      "index");
                                }
                              }
                              Navigator.pop(context);
                            }),
                      ),
                    ])))));
  }
}
