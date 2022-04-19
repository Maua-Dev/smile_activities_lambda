import 'utils/http.dart';
import 'package:http_methods/http_methods.dart';

class Router {
  final String path;
  final List<RouterHandler> _routes = [];
  Router(this.path);

  // Future<Response> call(Request request) async {
  //   // Note: this is a great place to optimize the implementation by building
  //   //       a trie for faster matching... left as an exercise for the reader :)
  //   for (var route in _routes) {
  //     if (route.verb != request.method.toUpperCase() && route.verb != 'ALL') {
  //       continue;
  //     }
  //     var params = route.match('/' + request.url.path);
  //     if (params != null) {
  //       final response = await route.invoke(request, params);
  //       if (response != routeNotFound) {
  //         return response;
  //       }
  //     }
  //   }
  //   return _notFoundHandler(request);
  // }

  void add(String verb, String route, Function handler) {
    if (!isHttpMethod(verb)) {
      throw ArgumentError.value(verb, 'verb', 'expected a valid HTTP method');
    }
    verb = verb.toUpperCase();

    if (verb == 'GET') {
      // Handling in a 'GET' request without handling a 'HEAD' request is always
      // wrong, thus, we add a default implementation that discards the body.
      _routes.add(RouterHandler('HEAD', route, handler));
    }
    _routes.add(RouterHandler(verb, route, handler));
  }

  void get(String route, Function handler) => add('GET', route, handler);

  void head(String route, Function handler) => add('HEAD', route, handler);

  void post(String route, Function handler) => add('POST', route, handler);

  void put(String route, Function handler) => add('PUT', route, handler);

  void delete(String route, Function handler) => add('DELETE', route, handler);
}

class RouterHandler {
  final String verb, route;
  final Function _handler;

  RouterHandler._(this.verb, this.route, this._handler);

  factory RouterHandler(String verb, String route, Function handler) {
    if (!route.startsWith('/')) {
      throw ArgumentError.value(
          route, 'route', 'expected route to start with a slash');
    }

    return RouterHandler._(verb, route, handler);
  }

  Future<HttpRequest> invoke(HttpRequest request) async {
    return await _handler(request);
  }
}
