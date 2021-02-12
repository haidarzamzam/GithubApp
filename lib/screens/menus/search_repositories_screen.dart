import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_app/app.dart';
import 'package:github_app/blocs/search/bloc.dart';
import 'package:github_app/screens/menus/detail_menu_screen.dart';
import 'package:github_app/utils/constants.dart';
import 'package:github_app/utils/toast.dart';
import 'package:github_app/utils/tools.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchRepositoryScreen extends StatefulWidget {
  @override
  _SearchRepositoryScreenState createState() => _SearchRepositoryScreenState();
}

class _SearchRepositoryScreenState extends State<SearchRepositoryScreen> {
  SearchBloc _searchBloc;
  List<dynamic> _myDataRepositories = List();
  ScrollController _scrollController;
  int pageCount = 1;
  bool _isLoading = true;
  bool _isMax = false;
  bool _isEmpty = false;
  bool _isSortIndex = false;
  String date = "";
  String search = "doraemon";
  SharedPreferences _prefs = App().sharedPreferences;

  @override
  void initState() {
    _scrollController = new ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
    _searchBloc = BlocProvider.of<SearchBloc>(context);
    if (_prefs.getString(ConstansString.TYPE_SORT_REPOSITORIES) == "loading") {
      _isSortIndex = false;
    } else if (_prefs.getString(ConstansString.TYPE_SORT_REPOSITORIES) ==
        "index") {
      _isSortIndex = true;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _searchBloc.add(GetSearchRepositoriesEvent(
            q: search,
            perPage: "10",
            page: 1,
            type: _prefs.getString(ConstansString.TYPE_SORT_REPOSITORIES)));
      }
    });

    super.initState();
  }

  _scrollListener() {
    if (!_isSortIndex) {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        setState(() {
          _isLoading = true;
          if (_isLoading) {
            if (_isMax) {
              _isLoading = false;
              ToastUtils.show("No more data");
            } else {
              pageCount = pageCount + 1;
              _searchBloc.add(GetSearchRepositoriesEvent(
                  q: search,
                  perPage: "10",
                  page: pageCount,
                  type:
                      _prefs.getString(ConstansString.TYPE_SORT_REPOSITORIES)));
            }
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _searchBloc,
      listener: (context, state) {
        if (state is GetSearchRepositoriesSuccessState) {
          _isLoading = false;
          search = state.q;
          setState(() {
            pageCount = state.page;
          });

          if (_isSortIndex) {
            var data = jsonEncode(state.result.items);
            var listUsers = JsonDecoder().convert(data);
            _myDataRepositories = listUsers;
          } else {
            if (state.page == 1) {
              if (state.result.items.isEmpty) {
                _isEmpty = true;
              } else {
                _isEmpty = false;
              }
              var data = jsonEncode(state.result.items);
              var listRepositories = JsonDecoder().convert(data);
              _myDataRepositories = listRepositories;
            } else if (state.page > 1) {
              if (state.result.items.isEmpty) {
                _isMax = true;
              } else {
                if (state.result.items.isEmpty) {
                  _isEmpty = true;
                } else {
                  _isEmpty = false;
                }
                var data = jsonEncode(state.result.items);
                var listRepositories = JsonDecoder().convert(data);
                _myDataRepositories.addAll(listRepositories);
              }
            }
          }
        } else if (state is GetSearchRepositoriesFailedState) {
          _isLoading = false;
          print(state.message);
          if (state.message != null) {
            ToastUtils.show("Please, try again");
          }
        } else if (state is DoSwitchSortState) {
          if (state.api == "repositories") {
            if (state.type == "loading") {
              _isSortIndex = false;
            } else if (state.type == "index") {
              _isSortIndex = true;
            }
          }
        }
      },
      child: BlocBuilder(
          bloc: _searchBloc,
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: LoadingOverlay(
                color: Colors.white,
                isLoading: _isLoading,
                child: Stack(
                  children: [
                    Visibility(
                        visible: _isEmpty,
                        child: Center(
                            child: Text(
                                "Search does not exist, Please correct keywords."))),
                    ListView.builder(
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        DateTime todayDate = DateTime.parse(
                            _myDataRepositories[index]['created_at']);
                        final DateFormat formatter = DateFormat('dd-MM-yyyy');
                        date = formatter.format(todayDate);

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailMenuScreen(
                                        url: _myDataRepositories[index]
                                            ['html_url'],
                                        title: _myDataRepositories[index]
                                            ['name'],
                                      )),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        _myDataRepositories[index]['owner']
                                        ['avatar_url']),
                                    radius: 35.0),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _myDataRepositories[index]['name'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          date,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.star_border_outlined),
                                            Text(
                                                "${_myDataRepositories[index]['stargazers_count']}"),
                                            SizedBox(width: 8.0),
                                            Icon(Icons.remove_red_eye_outlined),
                                            Text(
                                                "${_myDataRepositories[index]['watchers_count']}"),
                                            SizedBox(width: 8.0),
                                            Icon(Icons.usb),
                                            Text(
                                                "${_myDataRepositories[index]['forks_count']}")
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: _myDataRepositories.length,
                    ),
                    Visibility(
                        visible: _isSortIndex,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: Colors.black38,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  MaterialButton(
                                    onPressed: () {
                                      if (pageCount == 1) {
                                        ToastUtils.show("Already early limit");
                                      } else {
                                        _isLoading = true;
                                        _searchBloc.add(
                                            GetSearchRepositoriesEvent(
                                                q: search,
                                                perPage: "10",
                                                page: pageCount - 1,
                                                type: _prefs.getString(
                                                    ConstansString
                                                        .TYPE_SORT_REPOSITORIES)));
                                      }
                                    },
                                    color: HexColor(Settings['MainColor']),
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 14.0),
                                  Text(
                                    pageCount.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24.0,
                                        color: Colors.white),
                                  ),
                                  SizedBox(width: 14.0),
                                  MaterialButton(
                                    onPressed: () {
                                      _isLoading = true;
                                      _searchBloc.add(
                                          GetSearchRepositoriesEvent(
                                              q: search,
                                              perPage: "10",
                                              page: pageCount + 1,
                                              type: _prefs.getString(
                                                  ConstansString
                                                      .TYPE_SORT_REPOSITORIES)));
                                    },
                                    color: HexColor(Settings['MainColor']),
                                    child: Icon(Icons.arrow_forward_ios,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future<Null> _onRefresh() async {
    pageCount = 1;
    _isMax = false;
    _searchBloc.add(GetSearchRepositoriesEvent(
        q: search,
        perPage: "10",
        page: 1,
        type: _prefs.getString(ConstansString.TYPE_SORT_REPOSITORIES)));
    return;
  }
}
