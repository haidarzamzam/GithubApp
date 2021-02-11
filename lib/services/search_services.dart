import 'package:dio/dio.dart';
import 'package:github_app/app.dart';
import 'package:github_app/models/search_issues_response.dart';
import 'package:github_app/models/search_repositories_response.dart';
import 'package:github_app/models/search_users_response.dart';
import 'package:github_app/utils/end_point.dart';

Dio _dio = App().dio;

Future<SearchRepositoriesResponse> getSearchRepositories(
    Map<String, dynamic> payload) async {
  Response response = await _dio.get(
    Endpoint.listSearchRepositories,
    queryParameters: {
      "q": payload['q'],
      "per_page": payload['per_page'],
      "page": payload['page']
    },
  );

  if (response.statusCode == 200) {
    print(response.data);
    return SearchRepositoriesResponse.fromJson(response.data);
  }
}

Future<SearchUsersResponse> getUsersRepositories(
    Map<String, dynamic> payload) async {
  Response response = await _dio.get(
    Endpoint.listUsers,
    queryParameters: {
      "q": payload['q'],
      "per_page": payload['per_page'],
      "page": payload['page']
    },
  );

  if (response.statusCode == 200) {
    print(response.data);
    return SearchUsersResponse.fromJson(response.data);
  }
}

Future<SearchIssuesResponse> getIssuesRepositories(
    Map<String, dynamic> payload) async {
  Response response = await _dio.get(
    Endpoint.listIssues,
    queryParameters: {
      "q": payload['q'],
      "per_page": payload['per_page'],
      "page": payload['page']
    },
  );

  if (response.statusCode == 200) {
    print(response.data);
    return SearchIssuesResponse.fromJson(response.data);
  }
}
