import 'package:equatable/equatable.dart';
import 'package:kwik/models/subcategory_model.dart';

import '../../models/category_model.dart';

abstract class CategoryBloc8State extends Equatable {
  @override
  List<Object> get props => [];
}

class Categorymode8Initial extends CategoryBloc8State {}

class Categorymode8Loading extends CategoryBloc8State {}

class Categorymode8Loaded extends CategoryBloc8State {
  final List<SubCategoryModel> categories;

  Categorymode8Loaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class Categorymode8Error extends CategoryBloc8State {
  final String message;

  Categorymode8Error(this.message);

  @override
  List<Object> get props => [message];
}
