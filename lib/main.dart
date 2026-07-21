import 'app/app.dart';
import 'bootstrap/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
