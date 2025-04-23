import 'package:equatable/equatable.dart';
import 'package:kwik/models/address_model.dart' as AddressModel;
import 'package:kwik/models/order_model.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class LocationSearchResults extends AddressState {
  final List<Location> locations;
  final List<String> addresses;

  const LocationSearchResults(this.locations, this.addresses);

  @override
  List<Object> get props => [locations, addresses];
}

class LocationSelected extends AddressState {
  final Location selectedLocation;
  final String selectedAddress;

  const LocationSelected(this.selectedLocation, this.selectedAddress);

  @override
  List<Object> get props => [selectedLocation, selectedAddress];
}

class AddressSaved extends AddressState {
  final AddressModel.AddressModel address;

  const AddressSaved(this.address);

  @override
  List<Object> get props => [address];
}

class AddressError extends AddressState {
  final String message;

  const AddressError(this.message);

  @override
  List<Object> get props => [message];
}
