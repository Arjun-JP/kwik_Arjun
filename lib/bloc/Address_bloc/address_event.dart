import 'package:equatable/equatable.dart';
import 'package:kwik/models/address_model.dart' as AddressModel;
import 'package:kwik/models/order_model.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class SearchLocation extends AddressEvent {
  final String query;

  const SearchLocation(this.query);

  @override
  List<Object> get props => [query];
}

class SelectLocation extends AddressEvent {
  final Location location;
  final String address;

  const SelectLocation(this.location, this.address);

  @override
  List<Object> get props => [location, address];
}

class SaveAddress extends AddressEvent {
  final AddressModel.AddressModel address;

  const SaveAddress(this.address);

  @override
  List<Object> get props => [address];
}

class GetCurrentLocation extends AddressEvent {}
