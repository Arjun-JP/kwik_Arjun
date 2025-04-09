import 'package:equatable/equatable.dart';
import 'package:kwik/models/address_model.dart';

abstract class AddressState extends Equatable {
  @override
  List<Object?> get props => [];
}

// State when no addresses exist, only warehouse info is available
class AddressInitial extends AddressState {
  final String warehouseId;

  AddressInitial(this.warehouseId);

  @override
  List<Object?> get props => [warehouseId];
}

// State when at least one address exists
class AddressAdded extends AddressState {
  final List<AddressModel> addresses;
  final AddressModel defaultAddress;
  final String warehouseId;

  AddressAdded({
    required this.addresses,
    required this.defaultAddress,
    required this.warehouseId,
  });

  @override
  List<Object?> get props => [addresses, defaultAddress, warehouseId];
}
