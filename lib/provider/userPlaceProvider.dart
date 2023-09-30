import 'package:estateease/models/SearchPlace.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userPlace = Provider<SearchPlace>((ref) {
  return SearchPlace(country: "India", state: "Gujarat", city: "Surat");
});
