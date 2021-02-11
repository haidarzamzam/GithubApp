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
    Size size = MediaQuery.of(context).size;
    return BlocListener(
      bloc: _searchBloc,
      listener: (context, state) {
        if (state is GetSearchUsersSuccessState) {
          print("cekk" + state.result.items[0].login.toString());
          _isLoading = false;
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
            ToastUtils.show("Silahkan diulang kembali");
          }
        }
      },
      child: BlocBuilder(
          bloc: _searchBloc,
          builder: (context, state) {
            return Scaffold(
                body: RefreshIndicator(
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
                                "Pencarian tidak ada, Harap perbaiki kata kunci."))),
                    ListView.builder(
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: size.height * 0.035,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      border: Border.all(
                                          color: Colors.transparent,
                                          width: 1.0),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5.0),
                                          topLeft: Radius.circular(5.0)),
                                    ),
                                    child: Center(
                                      child: Text(_myDataUsers[index]['login'],
                                          textAlign: TextAlign.center,
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: _myDataUsers.length,
                    ),
                  ],
                ),
              ),
            ));
          }),
    );
  }

  Future<Null> _onRefresh() async {
    pageCount = 1;
    _isMax = false;
    search = "doraemon";
    _searchBloc.add(GetSearchUsersEvent(q: "", perPage: "10", page: 1));
    return;
  }
}
