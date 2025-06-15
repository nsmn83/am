import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:am_project/models/user.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(
    //baseUrl: 'http://192.168.0.107:8000/api/',
    //baseUrl: 'http://127.0.0.1:8000/api/',
    baseUrl: 'http://192.168.0.178:8000/api/',
    //baseUrl:'http://10.0.2.2:8000/api/',
    headers: {'Content-Type': 'application/json'},
  ));

  String? _token;
  String? _refreshToken;

  String? get token => _token;

  AuthService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
  if (_token != null &&
      !options.path.endsWith('login/') &&
      !options.path.endsWith('register/')) {
    options.headers['Authorization'] = 'Bearer $_token';
  }
  handler.next(options);
},
        onError: (DioError error, handler) async {
          if (error.response?.statusCode == 401) {
            final prefs = await SharedPreferences.getInstance();
            _refreshToken = prefs.getString('refresh_token');
            
            if (_refreshToken == null) {
              return handler.next(error);
            }

            try {
              final refreshResponse = await _dio.post('token/refresh/', data: {
                'refresh': _refreshToken,
              });

              _token = refreshResponse.data['access'];
              _refreshToken = refreshResponse.data['refresh'] ?? _refreshToken;

              await prefs.setString('auth_token', _token!);
              if (_refreshToken != null) {
                await prefs.setString('refresh_token', _refreshToken!);
              }

              final options = error.requestOptions;
              options.headers['Authorization'] = 'Bearer $_token';

              final response = await _dio.fetch(options);
              return handler.resolve(response);

            } catch (e) {
              await logout();
              return handler.next(error);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> updateUserProfile({
  required String image,
  required String bio,
}) async {
  final data = {
    'bio': bio,
    'profile_image_url': image,
  };

  final response = await _dio.patch('user/edit-bio/', data: data);

  return response.data;
}



  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _refreshToken = prefs.getString('refresh_token');
    print('Loaded access token: $_token');
    print('Loaded refresh token: $_refreshToken');
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _dio.post('login/', data: {
        'email': email,
        'password': password,
      });
      print('Login response: ${response.data}');
      
      _token = response.data['tokens']['access'];
      _refreshToken = response.data['tokens']['refresh'];
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      await prefs.setString('refresh_token', _refreshToken!);
      
      final userData = response.data;
      print('Tokens and user saved to SharedPreferences');
      
      return {
        'user': User.fromJson(userData),
        'access_token': _token,
        'refresh_token': _refreshToken,
      };
    } catch (e) {
      print('Login failed: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> register(String username, String email, String password1, String password2) async {
    try {
      final response = await _dio.post('register/', data: {
        'username': username,
        'email': email,
        'password1': password1,
        'password2': password2,
      });

      print('Response from server: ${response.data}');

      _token = response.data['tokens']['access'];
      _refreshToken = response.data['tokens']['refresh']; 
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      await prefs.setString('refresh_token', _refreshToken!);

      final userData = response.data;
      print('Tokens and user saved to SharedPreferences');

      return {
        'user': User.fromJson(userData),
        'access_token': _token,
        'refresh_token': _refreshToken,
      };
    } catch (e) {
      print('Registration failed: $e');
      return null;
    }
  }

Future<void> logout() async {
  try {
    final prefs = await SharedPreferences.getInstance();
final refreshToken = prefs.getString('refresh_token');

await _dio.post(
  'logout/',
  data: {'refresh': refreshToken},
  options: Options(
    headers: {'Authorization': 'Bearer $_token'},
  ),
);
  } catch (e) {
    print('Logout request failed: $e');
  }

  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
  await prefs.remove('refresh_token');
  _token = null;
  _refreshToken = null;
}
  Dio get dio => _dio;
}