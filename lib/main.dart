import 'package:conversation_maker/my_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'di/provider_setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp(await buildProvidersTree()));
}

// update conversation on server depend on conversation last update time :D
