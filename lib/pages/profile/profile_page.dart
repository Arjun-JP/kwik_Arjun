import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/constants/doted_devider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 244, 244),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        shadowColor: const Color.fromARGB(255, 236, 236, 236),
        elevation: .1,
        leading: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            context.pop();
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Colors.black,
          ),
        ),
        title: Text(
          "profile",
          style: theme.textTheme.headlineMedium!.copyWith(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 15,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40, // Adjust the size
                    backgroundImage: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/kwikgroceries-8a11e.firebasestorage.app/o/image%2023.png?alt=media&token=9925215f-e0eb-4a12-8431-281cea504c44"),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Arjun",
                        style: theme.textTheme.headlineMedium!
                            .copyWith(color: Colors.black),
                      ),
                      Text(
                        "8547062699",
                        style: theme.textTheme.bodyMedium!.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      )
                    ],
                  )
                ],
              ),
              Row(
                spacing: 20,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.blueGrey, width: .1)),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.shopping_bag_outlined,
                            size: 30,
                          ),
                          Text(
                            "Your\nOrders",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.blueGrey, width: .1)),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.chat_outlined,
                            size: 30,
                          ),
                          Text(
                            "Help &\nSupport",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.blueGrey, width: .1)),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.person_outlined,
                            size: 30,
                          ),
                          Text(
                            "Edit &\nProfile",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "More Information",
                style: theme.textTheme.titleMedium!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 20,
                  children: [
                    Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            size: 25,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            "Your Orders",
                            style: theme.textTheme.bodyMedium!
                                .copyWith(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const DottedDivider(
                      height: 1,
                      color: Color.fromARGB(255, 211, 210, 210),
                      dashWidth: 10, // Length of each dash
                      dashSpace: 4, // Space between dashes
                    ),
                    Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.chat_outlined,
                            size: 25,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            "Help & Support",
                            style: theme.textTheme.bodyMedium!
                                .copyWith(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const DottedDivider(
                      height: 1,
                      color: Color.fromARGB(255, 211, 210, 210),
                      dashWidth: 10, // Length of each dash
                      dashSpace: 4, // Space between dashes
                    ),
                    Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.format_align_left_rounded,
                            size: 25,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            "Terms & Conditions",
                            style: theme.textTheme.bodyMedium!
                                .copyWith(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const DottedDivider(
                      height: 1,
                      color: Color.fromARGB(255, 211, 210, 210),
                      dashWidth: 10, // Length of each dash
                      dashSpace: 4, // Space between dashes
                    ),
                    Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.lock_outline,
                            size: 25,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            "Privacy Policy",
                            style: theme.textTheme.bodyMedium!
                                .copyWith(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.chat_outlined,
                        size: 25,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        "Log Out",
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
