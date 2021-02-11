import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_app/blocs/search/bloc.dart';
import 'package:github_app/utils/toast.dart';
import 'package:loading_overlay/loading_overlay.dart';

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
  String search = "doraemon";

  @override
  void initState() {
    _scrollController = new ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
    _searchBloc = BlocProvider.of<SearchBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _searchBloc
            .add(GetSearchRepositoriesEvent(q: search, perPage: "10", page: 1));
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
            _searchBloc.add(GetSearchRepositoriesEvent(
                q: search, perPage: "10", page: pageCount));
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
        if (state is GetSearchRepositoriesSuccessState) {
          _isLoading = false;
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
        } else if (state is GetSearchRepositoriesFailedState) {
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
                                          _myDataRepositories[index]
                                              ['created_at'],
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
    search = "doraemon";
    _searchBloc.add(GetSearchRepositoriesEvent(q: "", perPage: "10", page: 1));
    return;
  }
}
