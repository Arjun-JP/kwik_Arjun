import 'package:equatable/equatable.dart';
import 'package:kwik/models/address_model.dart';

abstract class AddressEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Fetch addresses from the server
class FetchAddresses extends AddressEvent {}

// Add a new address
class AddAddress extends AddressEvent {
  final AddressModel address;
  final String userID;

  AddAddress({required this.address, required this.userID});

  @override
  List<Object?> get props => [address, userID];
}

// Edit an existing address
class EditAddress extends AddressEvent {
  final AddressModel updatedAddress;

  EditAddress(this.updatedAddress);

  @override
  List<Object?> get props => [updatedAddress];
}

// Delete an address
class DeleteAddress extends AddressEvent {
  final AddressModel address;

  DeleteAddress(this.address);

  @override
  List<Object?> get props => [address];
}

// Set an address as default
class SetDefaultAddress extends AddressEvent {
  final AddressModel address;

  SetDefaultAddress(this.address);

  @override
  List<Object?> get props => [address];
}
