import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/get_appdata_bloc/get_appdata_bloc.dart';
import 'package:kwik/bloc/get_appdata_bloc/get_appdata_event.dart';
import 'package:kwik/bloc/get_appdata_bloc/get_appdata_state.dart';
import 'package:kwik/constants/network_check.dart';
import 'package:kwik/widgets/shimmer/privacy_policy_shimmer.dart';

class TermsAndConditionPage extends StatefulWidget {
  final String terms;

  const TermsAndConditionPage({super.key, required this.terms});

  @override
  State<TermsAndConditionPage> createState() => _TermsAndConditionPageState();
}

class _TermsAndConditionPageState extends State<TermsAndConditionPage> {
  List<String> _splitIntoParagraphs(String text) {
    return text.split('\n\n'); // Double new line as paragraph separator
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NetworkUtils.checkConnection(context);
    });
    context.read<GetAppdataBloc>().add(Loadappdata());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final paragraphs = _splitIntoParagraphs(widget.terms);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: const Color.fromARGB(255, 255, 248, 241),
      ),
      body: BlocBuilder<GetAppdataBloc, GetAppdataState>(
          builder: (context, state) {
        if (state is GetappdataLoading) {
          return const PrivacyPolicyShimmer();
        } else if (state is GetappdataLoaded) {
          final termsofuse =
              _splitIntoParagraphs(state.content['terms_of_use']);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/kwiklogo.png",
                    height: 120,
                  ),
                ),
                const SizedBox(height: 20),
                ...termsofuse.map((para) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        para.trim(),
                        style: const TextStyle(fontSize: 12, height: 1.5),
                      ),
                    )),
              ],
            ),
          );
        }
        if (state is GetappdataError) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/kwiklogo.png",
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
