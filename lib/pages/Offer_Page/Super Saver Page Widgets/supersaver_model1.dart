import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/repositories/category_model2_repository.dart';

import '../../../bloc/Super Saver Page Bloc/supersaver_model1_bloc/supersaver_model1_bloc.dart';
import '../../Category_page/Categories Page Widgets/categories_page_model2.dart';

class SupersaverModel1 extends StatelessWidget {
  final String categoryId;
  final String bgcolor;
  final String subcatcolor1;
  final String subcatcolor2;
  final String titleColor;
  final String priceColor;
  final String vegOrNonIcon;
  final String seeAllButtonBG;
  final String seeAllButtontext;
  const SupersaverModel1(
      {super.key,
      required this.categoryId,
      required this.bgcolor,
      required this.subcatcolor1,
      required this.subcatcolor2,
      required this.titleColor,
      required this.priceColor,
      required this.vegOrNonIcon,
      required this.seeAllButtonBG,
      required this.seeAllButtontext});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupersaverModel1BlocBloc(
          categoryRepositoryModel2: CategoryRepositoryModel2())
        ..add(FetchCategoryDetailsSuperSave1(categoryId)),
      child: Builder(
        builder: (context) {
          return BlocBuilder<SupersaverModel1BlocBloc,
              SupersaverModel1BlocState>(
            builder: (context, state) {
              if (state is SupersaverModel1Loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SupersaverModel1Loaded) {
                return Container(
                  color: parseColor(bgcolor),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        "Nuts, Seeds & Berries",
                        //state.category.name,
                        style: TextStyle(
                            color: parseColor(titleColor),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 294,
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                          itemCount: state.subCategories.length,
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.2,
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            return subcategoryItem(
                              titleColor: titleColor,
                              name: state.subCategories[index].name,
                              bgcolor: state.category.color,
                              textcolor: titleColor,
                              imageurl: state.subCategories[index].imageUrl,
                              subcatcolor1: subcatcolor1,
                              subcatcolor2: subcatcolor2,
                              priceColor: priceColor,
                              vegOrNonIcon: vegOrNonIcon,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: parseColor(subcatcolor1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('See all Categories',
                                    style: TextStyle(
                                        color: parseColor(priceColor),
                                        fontSize: 18)),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 14.0),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: parseColor(priceColor),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              } else if (state is SupersaverModel1Error) {
                return Center(child: Text(state.message));
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }
}
