import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/widgets/shimmer/super_saver_model1_shimmer.dart';
import '../../../bloc/Super Saver Page Bloc/supersaver_model1_bloc/supersaver_model1_bloc.dart';
import '../../../repositories/offerzone_cat1_repo.dart';

class SupersaverModel1 extends StatelessWidget {
  final String categoryId;
  final String bgcolor;
  final String subcatcolor1;
  final String subcatcolor2;
  final String title;
  final String titleColor;
  final String priceColor;
  final String vegOrNonIcon;
  final String startattext;
  final String cattitleColor;

  final bool showCategory;
  const SupersaverModel1({
    super.key,
    required this.categoryId,
    required this.bgcolor,
    required this.subcatcolor1,
    required this.subcatcolor2,
    required this.titleColor,
    required this.priceColor,
    required this.vegOrNonIcon,
    required this.startattext,
    required this.cattitleColor,
    required this.title,
    required this.showCategory,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return showCategory
        ? BlocProvider(
            create: (context) =>
                SupersaverModel1BlocBloc(offerzoneCat1Repo: OfferzoneCat1Repo())
                  ..add(FetchCategoryDetailsSuperSave1(categoryId)),
            child: Builder(
              builder: (context) {
                return BlocBuilder<SupersaverModel1BlocBloc,
                    SupersaverModel1BlocState>(
                  builder: (context, state) {
                    if (state is SupersaverModel1Loading) {
                      return const Center(child: SuperSaverModel1Shimmer());
                    } else if (state is SupersaverModel1Loaded) {
                      return Container(
                        color: parseColor(bgcolor),
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                title,
                                //state.category.name,
                                style: TextStyle(
                                    color: parseColor(titleColor),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 256,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: StaggeredGrid.count(
                                      axisDirection: AxisDirection.right,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 20,
                                      children: List.generate(
                                        state.subCategories.length,
                                        (index) {
                                          return InkWell(
                                            onTap: () => context.push(
                                                "/allsubcategorypage?categoryId=${state.subCategories[index].categoryRef.catref}&selectedsubcategory=${state.subCategories[index].id}"),
                                            child: subcategoryItemOffer(
                                                theme: theme,
                                                titleColor: titleColor,
                                                name: state
                                                    .subCategories[index].name,
                                                offer: state
                                                    .subCategories[index]
                                                    .offerPercentage,
                                                bgcolor: state.category.color,
                                                textcolor: titleColor,
                                                imageurl: state
                                                    .subCategories[index]
                                                    .imageUrl,
                                                subcatcolor1: subcatcolor1,
                                                subcatcolor2: subcatcolor2,
                                                priceColor: priceColor,
                                                vegOrNonIcon: vegOrNonIcon,
                                                cattitleColor: cattitleColor),
                                          );
                                        },
                                      ),
                                    ),
                                  )),
                            ),
                            const SizedBox(height: 20),
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
          )
        : const SizedBox();
  }

  Widget subcategoryItemOffer(
      {required ThemeData theme,
      required String offer,
      required String name,
      required String bgcolor,
      required String textcolor,
      required String cattitleColor,
      required String subcatcolor1,
      required String subcatcolor2,
      required String priceColor,
      required String titleColor,
      required String vegOrNonIcon,
      required String imageurl}) {
    return Container(
      width: 175,
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              parseColor(subcatcolor1),
              parseColor(subcatcolor2),
              parseColor(subcatcolor1)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 90,
                child: Text(name,
                    maxLines: 2,
                    style: theme.textTheme.bodyMedium!
                        .copyWith(color: parseColor(cattitleColor))),
              ),
              const SizedBox(height: 5),
              Text(
                "Starts at",
                style: TextStyle(fontSize: 12, color: parseColor(startattext)),
              ),
              const SizedBox(height: 3),
              RichText(
                text: TextSpan(
                  text: "₹",
                  style: theme.textTheme.bodyLarge!
                      .copyWith(color: parseColor(priceColor)),
                  children: [
                    TextSpan(
                      text: offer,
                      style: theme.textTheme.bodyLarge!
                          .copyWith(color: parseColor(priceColor)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          ClipRRect(
            borderRadius:
                const BorderRadius.only(bottomRight: Radius.circular(12)),
            child: Image.network(
              imageurl,
              width: 60,
              height: 260,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 5)
        ],
      ),
    );
  }
}
