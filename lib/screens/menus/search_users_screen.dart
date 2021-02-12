import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_app/app.dart';
import 'package:github_app/blocs/search/bloc.dart';
import 'package:github_app/screens/menus/detail_menu_screen.dart';
import 'package:github_app/utils/constants.dart';
import 'package:github_app/utils/dialog.dart';
import 'package:github_app/utils/toast.dart';
import 'package:github_app/utils/tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchUsersScreen extends StatefulWidget {
  @override
  _SearchUsersScreenState createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  SearchBloc _searchBloc;
  List<dynamic> _myDataUsers = List();
  ScrollController _scrollController;
  int pageCount = 1;
  bool _isLoading = true;
  bool _isMax = false;
  bool _isEmpty = false;
  bool _isSortIndex = false;
  String search = "doraemon";
  SharedPreferences _prefs = App().sharedPreferences;

  @override
  void initState() {
    _scrollController = new ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
    _searchBloc = BlocProvider.of<SearchBloc>(context);
    if (_prefs.getString(ConstansString.TYPE_SORT_USERS) == "loading") {
      _isSortIndex = false;
    } else if (_prefs.getString(ConstansString.TYPE_SORT_USERS) == "index") {
      _isSortIndex = true;
    }
    if (_prefs.getString(ConstansString.KEYWORD_USERS) != null) {
      search = _prefs.getString(ConstansString.KEYWORD_USERS);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _searchBloc.add(DoGetDataEvent(isLoading: true));
        _searchBloc.add(GetSearchUsersEvent(
            q: search,
            perPage: "10",
            page: 1,
            type: _prefs.getString(ConstansString.TYPE_SORT_USERS)));
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
              _searchBloc.add(DoGetDataEvent(isLoading: true));
              _searchBloc.add(GetSearchUsersEvent(
                  q: search,
                  perPage: "10",
                  page: pageCount,
                  type: _prefs.getString(ConstansString.TYPE_SORT_USERS)));
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
      listener: (context, state) async {
        if (state is GetSearchUsersSuccessState) {
          _isLoading = false;
          _searchBloc.add(DoGetDataEvent(isLoading: false));
          search = state.q;
          setState(() {
            pageCount = state.page;
          });
          if (_isSortIndex) {
            var data = jsonEncode(state.result.items);
            var listUsers = JsonDecoder().convert(data);
            _myDataUsers = listUsers;
          } else {
            if (state.page == 1) {
              if (state.result.items.isEmpty) {
                _isEmpty = true;
              } else {
                _isEmpty = false;
              }
              var data = jsonEncode(state.result.items);
              var listUsers = JsonDecoder().convert(data);
              _myDataUsers = listUsers;
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
                var listUsers = JsonDecoder().convert(data);
                _myDataUsers.addAll(listUsers);
              }
            }
          }
        } else if (state is GetSearchUsersFailedState) {
          _isLoading = false;
          _searchBloc.add(DoGetDataEvent(isLoading: false));
          print(state.message);
          if (state.message == "403") {
            _searchBloc.add(DoGetDataEvent(isLoading: false));
            LoadingDialogWidget.showLoading(context);
            await Future.delayed(Duration(seconds: 30));
            Navigator.pop(context);
            _searchBloc.add(DoGetDataEvent(isLoading: true));
            _searchBloc.add(GetSearchUsersEvent(
                q: search,
                perPage: "10",
                page: pageCount,
                type: _prefs.getString(ConstansString.TYPE_SORT_USERS)));
          } else {
            ToastUtils.show("Please, try again");
          }
        } else if (state is DoSwitchSortState) {
          if (state.api == "users") {
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
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailMenuScreen(
                                      url: _myDataUsers[index]['html_url'],
                                      title: _myDataUsers[index]['login'],
                                    )),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      _myDataUsers[index]['avatar_url']),
                                  radius: 35.0),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    _myDataUsers[index]['login'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: _myDataUsers.length,
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
                                      _searchBloc
                                          .add(DoGetDataEvent(isLoading: true));
                                      _searchBloc.add(GetSearchUsersEvent(
                                          q: search,
                                          perPage: "10",
                                          page: pageCount - 1,
                                          type: _prefs.getString(
                                              ConstansString.TYPE_SORT_USERS)));
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
                                    _searchBloc
                                        .add(DoGetDataEvent(isLoading: true));
                                    _searchBloc.add(GetSearchUsersEvent(
                                        q: search,
                                        perPage: "10",
                                        page: pageCount + 1,
                                        type: _prefs.getString(
                                            ConstansString.TYPE_SORT_USERS)));
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
            );
          }),
    );
  }

  Future<Null> _onRefresh() async {
    pageCount = 1;
    _isMax = false;
    _searchBloc.add(DoGetDataEvent(isLoading: true));
    _searchBloc.add(GetSearchUsersEvent(
        q: search,
        perPage: "10",
        page: 1,
        type: _prefs.getString(ConstansString.TYPE_SORT_USERS)));
    return;
  }

  void switchTypeSort() {}
}
