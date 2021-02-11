import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_app/blocs/search/bloc.dart';
import 'package:github_app/utils/toast.dart';
import 'package:loading_overlay/loading_overlay.dart';

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
  String search = "doraemon";

  @override
  void initState() {
    _scrollController = new ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
    _searchBloc = BlocProvider.of<SearchBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _searchBloc.add(GetSearchUsersEvent(q: search, perPage: "10", page: 1));
      }
    });

    super.initState();
  }

  _scrollListener() {
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
            _searchBloc.add(
                GetSearchUsersEvent(q: search, perPage: "10", page: pageCount));
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _searchBloc,
      listener: (context, state) {
        if (state is GetSearchUsersSuccessState) {
          _isLoading = false;
          search = state.q;
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
        } else if (state is GetSearchUsersFailedState) {
          _isLoading = false;
          print(state.message);
          if (state.message != null) {
            ToastUtils.show("Please, try again");
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
                        return GestureDetector(
                          onTap: () {},
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
    _searchBloc.add(GetSearchUsersEvent(q: search, perPage: "10", page: 1));
    return;
  }
}
