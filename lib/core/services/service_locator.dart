import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/tickets/data/datasources/ticket_local_data_source.dart';
import '../../features/tickets/data/models/ticket_model.dart';
import '../../features/tickets/data/repositories/ticket_repository_impl.dart';
import '../../features/tickets/domain/repositories/ticket_repository.dart';
import '../../features/tickets/presentation/cubit/ticket_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> initServiceLocator() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TicketModelAdapter());

  final ticketsBox = await Hive.openBox<TicketModel>('tickets_box');
  sl.registerSingleton<Box<TicketModel>>(ticketsBox);

  sl.registerLazySingleton<TicketLocalDataSource>(
    () => TicketLocalDataSourceImpl(sl<Box<TicketModel>>()),
  );

  sl.registerLazySingleton<TicketRepository>(
    () => TicketRepositoryImpl(sl<TicketLocalDataSource>()),
  );

  sl.registerFactory<TicketCubit>(() => TicketCubit(sl<TicketRepository>()));
}
