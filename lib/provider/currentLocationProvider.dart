import 'package:estateease/models/Users.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentLocation = Provider<CurrentLocation>(
    (ref) => CurrentLocation(latitude: 0.0, longitude: 0.0));
