import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/get_appdata_bloc/get_appdata_bloc.dart';
import 'package:kwik/bloc/get_appdata_bloc/get_appdata_event.dart';
import 'package:kwik/bloc/get_appdata_bloc/get_appdata_state.dart';
import 'package:kwik/widgets/shimmer/privacy_policy_shimmer.dart';

class HelpAndSupportPage extends StatelessWidget {
  const HelpAndSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: const Color.fromARGB(255, 255, 248, 241),
      ),
      body: BlocBuilder<GetAppdataBloc, GetAppdataState>(
          builder: (context, state) {
        if (state is Getappdatainitial) {
          context.read<GetAppdataBloc>().add(Loadappdata());
        } else if (state is GetappdataLoading) {
          return const PrivacyPolicyShimmer();
        } else if (state is GetappdataLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/kwiklogo.png", // Use your own asset
                    height: 120,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  state.content['contact_us'],
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Text("Somthing went wrong plsease try again"),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: Text("Somthing went wrong plsease try again"),
          ),
        );
      }),
    );
  }
}

List<String> _splitIntoParagraphs(String text) {
  return text.split('\n\n'); // Double new line as paragraph separator
}
