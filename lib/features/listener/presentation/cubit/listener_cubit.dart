import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/listener_profile.dart';

/// App-wide: who is listening. Onboarding writes it once; home and the
/// sculptor read it.
class ListenerCubit extends Cubit<ListenerProfile> {
  ListenerCubit() : super(ListenerProfile.defaults);

  void save(ListenerProfile profile) => emit(profile);
}
