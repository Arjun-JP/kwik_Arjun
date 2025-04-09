import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/Address_bloc/Address_bloc.dart';
import 'package:kwik/bloc/Address_bloc/address_state.dart';

class AddressManagement extends StatelessWidget {
  const AddressManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressBloc, AddressState>(builder: (context, state) {
      return const Column(
        children: [
          Text("address page"),
        ],
      );
    });
  }
}
