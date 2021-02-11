import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_app/blocs/bloc_delegate.dart';
import 'package:github_app/utils/toast.dart';

class App {
  final String apiBaseURL;
  final String appTitle;
  static App _instance;
  Dio dio;

  App.configure({this.apiBaseURL, this.appTitle, this.dio}) {
    _instance = this;
  }

  factory App() {
    if (_instance == null) {
      throw UnimplementedError("App must be configured first.");
    }

    return _instance;
  }

  Future<Null> init() async {
    // configure bloc delegate
    BlocSupervisor.delegate = SimpleBlocDelegate();

    dio = Dio(BaseOptions(
        baseUrl: apiBaseURL,
        connectTimeout: 10000,
        receiveTimeout: 20000,
        responseType: ResponseType.json));
    setDioInterceptor();
  }

  void setDioInterceptor() {
    dio.interceptors.add(InterceptorsWrapper(onError: (DioError e) async {
      Map<String, dynamic> data = e.response.data;
      if (e.response.statusCode != null) {
        if (e.response.statusCode == 400) {
          ToastUtils.show(data['message']);
        }
      }
      return e;
    }));
  }
}
