import 'package:grpc/grpc_web.dart';
import 'package:injectable/injectable.dart';

@module
abstract class GrpcModule {
  @lazySingleton
  GrpcWebClientChannel provideChannel() {
    return GrpcWebClientChannel.xhr(
      Uri.parse('http://localhost:8080'),
    );
  }
}
