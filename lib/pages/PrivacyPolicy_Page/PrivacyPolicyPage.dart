import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/get_appdata_bloc/get_appdata_bloc.dart';
import 'package:kwik/bloc/get_appdata_bloc/get_appdata_event.dart';
import 'package:kwik/bloc/get_appdata_bloc/get_appdata_state.dart';
import 'package:kwik/widgets/shimmer/privacy_policy_shimmer.dart';

class PrivacyPolicyPage extends StatefulWidget {
  final String privacyText;

  const PrivacyPolicyPage({required this.privacyText});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  List<String> _splitIntoParagraphs(String text) {
    return text.split('\n\n'); // Double new line as paragraph separator
  }

  @override
  void initState() {
    context.read<GetAppdataBloc>().add(Loadappdata());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final paragraphs = _splitIntoParagraphs(widget.privacyText);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: const Color.fromARGB(255, 255, 248, 241),
      ),
      body: BlocBuilder<GetAppdataBloc, GetAppdataState>(
          builder: (context, state) {
        if (state is GetappdataLoading) {
          return const PrivacyPolicyShimmer();
        }
        if (state is GetappdataLoaded) {
          final privacypolicy =
              _splitIntoParagraphs(state.content['privacy_policy']);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/Screenshot 2025-01-31 at 6.20.37 PM.jpeg",
                    height: 120,
                  ),
                ),
                const SizedBox(height: 20),
                ...privacypolicy.map((para) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        para.trim(),
                        style: const TextStyle(fontSize: 12, height: 1.5),
                      ),
                    )),
              ],
            ),
          );
        } else if (state is GetappdataError) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/Screenshot 2025-01-31 at 6.20.37 PM.jpeg",
                    height: 120,
                  ),
                ),
                const SizedBox(height: 20),
                ...paragraphs.map((para) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        para.trim(),
                        style: const TextStyle(fontSize: 12, height: 1.5),
                      ),
                    )),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
