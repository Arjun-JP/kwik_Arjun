import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Bloc.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_Event.dart';
import 'package:kwik/bloc/home_Ui_bloc/home_Ui_State.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeUiBloc>(context).add(FetchUiDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeUiBloc, HomeUiState>(
        builder: (context, state) {
          if (state is UiInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UiLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UiLoaded) {
            final uiData = state.uiData;
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    categoys(
                      bgcolor: state.uiData["template4"]["background_color"],
                      catRef: state.uiData["categorylist"]["category_ref"][0],
                      categoryName: state.uiData["categorylist"]["category_ref"]
                          [0],
                    )
                  ],
                ),
              ),
            );
          } else if (state is UiError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          } else {
            return const Text('Unexpected state');
          }
        },
      ),
    );
  }
}

Widget categoys(
    {required String catRef,
    required String bgcolor,
    required String categoryName}) {
  print(bgcolor);
  return Container(
      width: 300,
      height: 200,
      color: Color(int.parse(combineStrings(str2: bgcolor))),
      child: Center(
        child: Text(categoryName),
      ));
}

String combineStrings({String str1 = "0x", required String str2}) {
  return str1 + str2;
}
