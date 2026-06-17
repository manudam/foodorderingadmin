import 'package:foodorderingadmin/config/backend_config.dart';
import 'package:pocketbase/pocketbase.dart';

class PocketBaseService {
  PocketBaseService._();

  static final PocketBase client = PocketBase(BackendConfig.pocketBaseUrl);
}
