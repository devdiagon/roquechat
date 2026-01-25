import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/identity_service.dart';

final identityServiceProvider = Provider<IdentityService>((ref) {
  return IdentityService();
});

final usernameProvider = FutureProvider<String>((ref) async {
  final service = ref.read(identityServiceProvider);
  return service.getOrCreateUsername();
});