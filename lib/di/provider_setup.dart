import 'package:conversation_maker/data/datasource/local/app_database.dart';
import 'package:conversation_maker/data/repository/repository_impl.dart';
import 'package:conversation_maker/di/provider/use_case_provider.dart';
import 'package:conversation_maker/di/provider/view_model_provider.dart';
import 'package:conversation_maker/domain/repository/repository.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<SingleChildCloneableWidget>> buildProvidersTree() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return [
    Provider.value(value: AppDatabase()),
    Provider.value(value: preferences),
    ProxyProvider<AppDatabase, Repository>(
        builder: (_, database, __) => RepositoryImpl(database.database)),
    ProxyProvider2<Repository, SharedPreferences, UseCaseProvider>(
        builder: (_, appRepository, preferences, __) =>
            UseCaseProvider(appRepository, preferences)),
    ProxyProvider<UseCaseProvider, ViewModelProvider>(
        builder: (_, useCaseProvider, __) => ViewModelProvider(useCaseProvider))
  ];
}
