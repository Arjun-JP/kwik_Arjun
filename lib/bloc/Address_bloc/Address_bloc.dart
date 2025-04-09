import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/Address_bloc/address_event.dart';
import 'package:kwik/bloc/Address_bloc/address_state.dart';
import 'package:kwik/models/address_model.dart';
import 'package:kwik/repositories/address_repo.dart' show AddressRepository;

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository addressRepository;

  AddressBloc({required this.addressRepository}) : super(AddressInitial("")) {
    on<FetchAddresses>(_onFetchAddresses);
    on<AddAddress>(_onAddAddress);
    on<EditAddress>(_onEditAddress);
    on<DeleteAddress>(_onDeleteAddress);
    on<SetDefaultAddress>(_onSetDefaultAddress);
  }

  Future<void> _emitBasedOnAddressList(
      List<AddressModel> addressList, Emitter<AddressState> emit) async {
    if (addressList.isEmpty) {
      // If address list is empty, emit initial state with warehouse ID from current location
      const locationPincode = "560003";
      final warehouseId =
          await addressRepository.getWarehouseRef(locationPincode);
      emit(AddressInitial(warehouseId));
    } else {
      // Otherwise, find default address and emit AddressAdded
      final defaultAddress = addressList.firstWhere(
        (element) => element.addressType.toLowerCase() == 'default',
        orElse: () => addressList.first,
      );
      final warehouseId =
          await addressRepository.getWarehouseRef(defaultAddress.pincode);
      emit(AddressAdded(
        addresses: addressList,
        defaultAddress: defaultAddress,
        warehouseId: warehouseId,
      ));
    }
  }

  Future<void> _onFetchAddresses(
      FetchAddresses event, Emitter<AddressState> emit) async {
    final addresses = await addressRepository.getAddressesFromServer();
    await _emitBasedOnAddressList(addresses, emit);
  }

  Future<void> _onAddAddress(
      AddAddress event, Emitter<AddressState> emit) async {
    await addressRepository.addAddress(event.address, event.userID);
    final addresses = await addressRepository.getAddressesFromServer();
    await _emitBasedOnAddressList(addresses, emit);
  }

  Future<void> _onEditAddress(
      EditAddress event, Emitter<AddressState> emit) async {
    await addressRepository.editAddress(event.updatedAddress);
    final addresses = await addressRepository.getAddressesFromServer();
    await _emitBasedOnAddressList(addresses, emit);
  }

  Future<void> _onDeleteAddress(
      DeleteAddress event, Emitter<AddressState> emit) async {
    await addressRepository.deleteAddress(event.address.flatNoName);
    final addresses = await addressRepository.getAddressesFromServer();
    await _emitBasedOnAddressList(addresses, emit);
  }

  Future<void> _onSetDefaultAddress(
      SetDefaultAddress event, Emitter<AddressState> emit) async {
    await addressRepository.setDefaultAddress(event.address.flatNoName);
    final addresses = await addressRepository.getAddressesFromServer();
    await _emitBasedOnAddressList(addresses, emit);
  }
}
