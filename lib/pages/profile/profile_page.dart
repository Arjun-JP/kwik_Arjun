import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/constants/doted_devider.dart';
import 'package:kwik/constants/network_check.dart';
import 'package:kwik/pages/Home_page/widgets/banner_model.dart';
import 'package:kwik/widgets/edit_profile_bottom_sheet.dart';
import 'package:kwik/widgets/logout_bottomsheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NetworkUtils.checkConnection(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
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
          "Profile",
          style: theme.textTheme.headlineMedium!
              .copyWith(fontWeight: FontWeight.w400, color: Colors.black),
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
                    radius: 30, // Adjust the size
                    child: Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 35,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Text(
                        user!.displayName ?? "Your account",
                        style: theme.textTheme.headlineMedium!.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.black),
                      ),
                      Text(
                        user!.phoneNumber!,
                        style: theme.textTheme.bodyMedium!.copyWith(
                            color: const Color.fromARGB(255, 142, 142, 142),
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  )
                ],
              ),
              Row(
                spacing: 20,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.push('/orders');
                      },
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
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.push('/help');
                      },
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
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return const UpdateProfileBottomSheet();
                          },
                        );
                      },
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
                    InkWell(
                      onTap: () {
                        context.push('/orders');
                      },
                      child: Row(
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
                    ),
                    const DottedDivider(
                      height: 1,
                      color: Color.fromARGB(255, 211, 210, 210),
                      dashWidth: 10, // Length of each dash
                      dashSpace: 4, // Space between dashes
                    ),
                    InkWell(
                      onTap: () {
                        context.push('/faq');
                      },
                      child: Row(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.question_answer_outlined,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              "FAQ",
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
                    ),
                    const DottedDivider(
                      height: 1,
                      color: Color.fromARGB(255, 211, 210, 210),
                      dashWidth: 10, // Length of each dash
                      dashSpace: 4, // Space between dashes
                    ),
                    InkWell(
                      onTap: () {
                        context.push('/help');
                      },
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
                    ),
                    const DottedDivider(
                      height: 1,
                      color: Color.fromARGB(255, 211, 210, 210),
                      dashWidth: 10, // Length of each dash
                      dashSpace: 4, // Space between dashes
                    ),
                    InkWell(
                      onTap: () {
                        context.pushNamed('terms', extra: {
                          'terms': '''
Kwik Terms Of Use
Version 1.0
 
This document is an electronic record and published in accordance with the provisions of the Information Technology Act, 2000 and the rules thereunder and the Information Technology (Intermediary Guidelines and Digital Media Ethics Code) Rules, 2021 and generated by a computer system and does not require any physical or digital signatures.
 
1. Terms of Use
 
1.1. The website https://www.kwikgrocery.shop/ (“Website”) and mobile application ‘Kwik’ (App) (Website and App collectively referred to as the “Platform”) is owned, operated and managed by the Dodani” or “proprietorship firm”), a proprietorship firm is primarily registered under the Shop and Establishment Act and having its registered office at Magnolia Oxygen A- II ROOM NO - ONE THOUSAND TWO KALABERIA,RAJARHAT POST OFFICE - RAJARHAT-BISHNUPUR PIN NO – 700135 .The proprietorship firm is the owner of website https://www.kwikgrocery.shop/ and its mobile application ‘Kwik’ (collectively, the “Platform”).
 
1.2. These terms of use (“Terms”) govern your use of the Platform, and for the purpose of these Terms, Dodani, its affiliates may wherever context so require, be also referred to as, “Kwik”, "We",  "Us", or "Our" and the terms “You”, “Your” or “User” refer to user of the Platform. We value the trust You have placed in Us and hence We maintain reasonable security standards for securing the transactions and Your information.
 
1.3. Please read these Terms carefully before you use the Platform. If you do not agree to these Terms, You may not use the services on the Platform, and we request you to uninstall the App and not access the Platform. By even merely using/accessing the Platform, You shall be contracting with Kwik and You signify Your acceptance to these Terms and other Kwik policies (including but not limited to the cancellation & refund Terms and published privacy policy (‘‘Privacy Notice’’) as posted on the Platform and amended from time to time, which takes effect on the date on which You use the Platform and thereby create a legally binding agreement to abide by the same. Further, by furnishing your personal information, you consent to Kwik accessing your personal information for the purpose of enabling transactions, you also agree that you are interested in availing the services through the Platform in accordance with these Terms.
 
1.4. Kwik retains an unconditional right to modify or amend these Terms. You can determine when these Terms were last modified by referring to the ‘Last Updated’ legend above. You can access the latest version of these Terms at any given time on the Platform. You should regularly review the Terms on the Platform. Kwik reserves the right to amend, suspend, discontinue or add any or all services without prior notice and can add or remove relevant terms and conditions, if necessary. Any updation of the Terms as a consequence of change in legal and regulatory compliances, shall be made in compliance thereof. Your continued use of and access to the Platform shall be your consent to any changes made by us in these Terms. In the event, the modified Terms are not acceptable to You, You should discontinue accessing the Platform.
 
2. Access to services
 
2.1. Kwik enables transactions on the Platform between participating sellers and service providers (“Seller(s)”) and Users. Users can order Products (defined hereunder) and services offered for sale by these Sellers in select serviceable areas across India. Kwik is not and cannot be a party to or control in any manner any transaction between the Platform's Users and Sellers.
 
2.2. You acknowledge that the Platform allows You to avail  a personal, limited, non-exclusive, non- transferable, and revocable privilege to access and use the Platform for the purposes of purchasing consumer goods such as grocery, apparel, electronics, health and wellness, café products including prepared foods and beverages (Café orders), Pet care etc (collectively, “Product(s)”) from the Sellers. The Services such as handling of Products, last mile delivery services including late night delivery and other services are provided with purchase of Products only at a fee as may be charged additionally.
 
2.3. The aforesaid revocable privilege to access does not include/permit resale or commercial use of the Platform or its Content (as defined below), in any manner. The Sellers may, at their discretion, add, modify or remove any of the Products and services listed above from time to time without notice. The Sellers and/or Kwik may also make applicable, at its discretion, additional terms and conditions specific to any category or section of Products or services in addition to these Terms and Your purchase of any of such category or section of Products or services shall also be governed by such additional terms and conditions. Kwik reserves the right to provide the services in any area or city in India, as may be determined by Kwik in its sole discretion. Before applying or registering for availing any of the services, We request You to please check if the services are available in Your area or city. Last mile delivery is provided by engaging third-party delivery service providers.
 
2.4. Kwik does not: (i) adopt any ‘unfair trade practices’ either on the Platform or otherwise with respect to its services; (ii) discriminate between Users of the same class or make any arbitrary classification of the Users and (iii) discriminate between the third-party delivery service providers.
 
2.5. Kwik functions solely as an online marketplace and acts as a facilitator enabling transactions between Users and Sellers on the Platform. At no point does Kwik take possession of any Products offered by Sellers nor does it hold any rights, title or interest in those Products and services. Kwik is not liable for any obligations related to nonperformance or breach of contracts between Users and Sellers as that is a bilateral arrangement between You and Seller. Furthermore, Kwik is neither responsible for poor or delayed Product or service performance nor for issues arising from Products that are out of stock, unavailable or back-ordered.
 
3. Eligibility to Use
 
3.1. The Products and services are not available to minors i.e., persons under the age of 18 (eighteen) years, undischarged insolvent, any Users who are not competent to enter into a contract under the Indian Contract Act, 1872, unless otherwise provided hereunder or to anyone previously suspended or removed by Kwik from availing the Products or services or accessing the Platform. You hereby represent that You are: (i) of legal age to form a binding contract, (ii) not a person barred from receiving the services from the Platform under the applicable laws;  (iii) competent to enter into a binding contract and (iv) have not been previously suspended or removed or disqualified for any reason from the Platform. If you are under the age of 18, You shall use and access the Platform only with the express consent of a parent or guardian and under their supervision.
 
3.2. You will not discriminate against third-party delivery service providers based on race, religion, caste, creed, national origin, disability, sexual orientation, sex, marital status, gender identity, age or any other metric which is deemed to be immoral and unlawful. Any credible proof of such discrimination, including any refusal to receive the Products or services based on the above metrics, whether alone or in conjunction with any other metric, shall render you ineligible, leading to suspension of access to the Platform. You will not have any claim, and we will not have any liability towards any such suspension.
 
3.3. You shall not make negative, defamatory, misleading, deceptive, or libelous remark about Us or Our brand, including Kwik and its agnates and cognates, on the Platform or otherwise, or take any actions that could harm Kwik's reputation or dilute its trademarks. Additionally, you will not impose an excessive load on the Platform's infrastructure or our systems and networks.
 
4. User Account, Password and Security
 
4.1. In order to access the services of the Platform, You will have to register and create an account on the Platform by providing details as may be required (“Account”). When you use the Platform, Kwik may collect personal information such as your name, email, age, photograph, address, mobile number, and contact details and also documents pertaining to the same. This includes demographic information like gender, occupation, and education, as well as your activity on the Platform such as visited pages, clicked links, and transaction details, including financial information needed to provide services and manage the Platform effectively.
 
4.2. You are solely responsible for the information you provide to us. You shall ensure and confirm that the Account information and all information provided by you is complete, accurate and up- to-date. If there is any change in the Account information, or if any information is found to be incomplete or incorrect, you shall promptly update Your Account information on the Platform or request Kwik for information revision or update. If the information provided by You is untrue, inaccurate, un authorized, not current, or incomplete (or becomes untrue, inaccurate, not current, or incomplete),  Kwik reserves the right to refuse any and all the services, if Kwik has reasonable grounds to suspect that such information is untrue, inaccurate, not current, or incomplete. Kwik reserves the right to refuse access to the Platform at any time without notice.
 
4.3. Confidentiality of the Account credentials shall be your responsibility. Kwik disclaims any liability for losses due to unauthorized access of your account.
 
5. Payment related Information
 
5.1. The information related to the accepted payment methods on the Platform shall be displayed during the purchasing process.
 
5.2. To the extent permitted by applicable law and subject to the Privacy Notice, You acknowledge and agree that Kwik may use certain third-party vendors and service providers, including payment gateways, to process payments and manage payment card information. Such Parties are separate to Kwik and you will be subject to their terms and conditions while making any payment for the Products and services.
 
5.3. You undertake to provide valid bank details or other details required for facilitating payment towards the transaction (“Payment   Details”). By providing the Payment Details, You represent, warrant, and covenant that: (a) You are legally authorized to provide such Payment Details; (b) You are legally authorized to make payments using such Payment Details; and (c) such action does not violate the terms and conditions applicable to your use of such Payment Details or applicable law. You may add, delete, and edit the Payment Details you have provided from time to time through the Platform.
 
5.4. Except to the extent otherwise required by applicable law, Kwik is not liable for any payments authorized through the Platform using Your Payment Details. Kwik is not liable for any payments that do not complete a transaction due to reasons including but not limited to following:
(a) Insufficient funds in your bank account;
(b) You have not provided correct Payment Details;
(c) Technical issues or interruptions in the Platform or payment processing systems.
(d) Violation of any terms or conditions governing the use of Your Payment Details.
(e) Fraudulent activity or unauthorized use of Your Payment Details.
(f) Your payment card has expired;
(g) Any other reason for declining of payment transaction or
(h) Any other circumstances beyond Kwik’s reasonable control which prevent the execution of the transaction.
 
5.5. Kwik shall not be responsible or obligated to refund any money to you for any unauthorized transactions conducted on the Platform using Your Payment Details.
‍
5.6. Gift Cards: You can use Kwik Gift Cards for the purchases on the Platform, by redeeming the value contained in such Gift Cards at the time of payment for the purchase of eligible Products or services only on the Platform. Gift Cards are subject to additional terms and conditions pertaining to their use and redemption and you agree and consent to abide by the same.
 
5.7. The payment facility facilitated by Kwik is neither a banking nor a financial service but is merely a facility providing an electronic, automated online electronic payment system, and receiving payment on delivery for the transactions on the Platform using the existing authorized banking infrastructure and card payment gateway networks, as may be applicable. For some payment methods, your payment service provider may charge you certain fees, such as transaction fees or other fees, relating to the processing of your transaction.
 
5.8. Title of any Products purchased by you on the Platform shall be transferred to you post you making applicable payment for the same and also comply with any requirements which are applicable for the order
 
6. Price of Products and services
 
6.1. The prices for Products and services listed by Sellers on the Platform are determined entirely by the Sellers themselves and Kwik does not participate in or influence this pricing process in any manner. The prices of each of the Products and services may vary due to various factors and you may check the price on the Platform before placing an order. By placing an order you agree to pay the prices mentioned therein. All the Products listed on the Platform will be sold at Indian Rupees either at Maximum Retail Price (MRP) (inclusive of all taxes) or at a discounted price unless otherwise specified. The prices of the Products and services are an offer for sale by the Sellers and may be modified by the Sellers from time to time without any prior notice. Kwik endeavor to display the Products and services at the accurate prices as possible on the Platform. There may be inadvertent errors with respect to the price and other information of the Products or services that you may bring to Our notice of such errors and We shall effect necessary corrections, however Kwik shall not be liable in case Seller proceeds with canceling of such order.
 
6.2. The Users will be informed about all the charges, fees, and costs (including delivery fee) that may be levied on the purchase of the Products or services on the Platform at the checkout page during a transaction.
 
6.3. The expression like 'Lowest Prices' pertains to the computation of average prices for all Products and services offered for sale by the Sellers on the Platform (in comparison to competitors in the quick commerce segment for groceries, in most of the cases) and are subject to availability of stocks. Kwik   expressly disclaims any liability associated with the individual Products or services sold on the Platform by the Sellers.
 
6.4. Promotional Vouchers: Promotional vouchers are issued under various nomenclatures such as Free Cash etc which are intended for instant use during a session or otherwise and shall lapse or expire unless used and are subject to revocation without any prior notice.
 
7. Delivery fees, ETA and other charges
 
7.1. The delivery fees cover the delivery services as part of the sale of Products purchased by you on the Platform. The delivery of the order will be provided within the time period communicated to you through the Platform. While efforts are made to display an estimated time of arrival (ETA) for every order, the delivery time may vary due to factors such as third-party delivery service availability, demand, traffic, weather conditions, force majeure events, and other unforeseen circumstances. Although Kwik endeavors to deliver orders within a 30-minute ETA, the actual delivery time may exceed this estimate due to the aforementioned factors. You can view the ETA on the homepage of the Platform even before placing an order, ensuring you are informed about the ETA before proceeding. Orders placed by you may be split into multiple sub-orders, each potentially having a different ETA.
 
7.2. Additionally, You agree that certain charges, such as fees for rain, peak hours, high demand or surge periods, late-night delivery, packaging and handling, convenience or platform usage, small cart fees, or other applicable charges, may apply. These charges will be displayed in the "View Bill" section before the checkout page on the Platform.  Your order may have following components and corresponding documents:
 
7.2.1. Supply of Products and services by Sellers - Tax Invoice issued on behalf of the Sellers;
 
7.2.2. Supply of services, if any, by Kwik - Tax Invoice issued by Kwik.
 
7.3. The delivery of the orders will be made to the address specified by you at the time of placing the order on the Platform. It is your sole responsibility to ensure that the delivery address is complete, accurate and includes any additional instructions required to facilitate delivery. Kwik and its Sellers shall not be liable for non-delivery or delays in delivery arising from an in corrector incomplete address provided by you.
 
7.4. The Products will ordinarily be delivered when an appropriate person is available to receive the order at the address provided by you. If You request that the delivery be left unattended at Your address, You expressly waive and release Kwik from any liability arising from the Products being left unattended, including, but not limited to, theft, tampering, contamination, or spoilage for any reasons including due to changes in temperature for items requiring chilled or frozen storage.
 
7.5. In the event You opt for ‘Cash on Delivery (CoD)’ mode, Seller/ third-party delivery service providers shall have the right to refuse delivery of the order to You if You fail to make the complete payment and Kwik shall treat such order as canceled order and shall not be liable for any losses or damage that may arise on account of such non delivery to You. You agree to pay the delivery fee or any other fees for such canceled order towards the cost incurred on such delivery attempt.
 
 
8. Returns, Cancellations and Refunds:
 
8.1. Returns:
 
8.1.1 You may return the Product in an order, subject to the satisfaction of the following conditions:
 
8.1.1.1. Wrong item being delivered other than what you had ordered in an order, or
8.1.1.2. Items substantially damaged or deteriorated in quality at the time of delivery. You agree that you shall give all the requisite proofs including but not limited to images of Products having issues.
 
8.1.2. You shall check the Products upon delivery and initiate exchange or return with the requisite proofs on the Platform, as available. You may also exchange or return the Product by contacting our customer support team.
 
8.1.3. You may request exchange or return of the Products, purchased from the Sellers provided that the Products are sealed/unopened/unused and in original condition and on the same day of delivery/or as per the exchange/refund timeline suggested by Seller/ displayed on product check out page, if any. Please note, the requests for exchange or returns will not be accepted from the day following the day when Product/s were delivered to You unless there are certain categories of the Products for which higher return or exchange period is provided. You are requested to dispose off the Products for which refund has been processed. It is clarified that your request for exchange or return of the Products shall only be processed if the relevant Seller accepts such request.
 
8.1.4. For digital products, including gift cards and vouchers, no returns or refunds are permitted. If you encounter any issues related to validity, usage restrictions, or redemption, You must contact the respective issuer. Please review the issuer or Platform’s terms and conditions which apply alongside these Terms.
 
8.2. Cancellations: You may cancel an order without charge at any time before the Seller accepts the order. You cannot cancel the order post acceptance of order. Your order may be canceled (in full or partially) for the reasons including shortage or unavailability of certain Products or force majeure events, no availability of services, unforeseen circumstances, delivery-related issues or if there are concerns regarding fraudulent activity or non-compliance with these Terms. In case of acceptance of cancellation of any order, you will not be charged for such cancellations and You will receive a refund for any payment already made, as early as practically possible.
 
8.3. Refunds: Please be informed that when you opt to return the Products, upon verification of the Products and the documents relating thereto, the refund amount for such Products which are eligible for return as per these Terms, will be processed within a period of seven (7) business days from the date of verifying and confirming the refund request. Your refund will be processed only when the conditions as may be stipulated by us are fulfilled. The refund amount will be credited to the source account. You acknowledge that after initiation of refund, it may take additional time for your refund to reflect in your account which is subject to your financial institution or payment gateway service provider terms and conditions. Provided that refunds, if any, for Products purchased on cash on delivery basis may also be refunded by way of coupon/vouchers which will have expiry period. Users may opt-in for a coupon/voucher refund for online payments as well if provided to them.
 
The Terms for acceptance of returns, cancellation and refunds shall be subject to reasonable additional conditions and shall be communicated to the User, from time to time.
 
9. User care:
 
9.1. The User acknowledges and agrees that Kwik shall not be held liable for:
 
9.1.1. The services or Products offered by Sellers, including but not limited to Café Orders that may or may not meet Your preferences or requirements.
9.1.2. The quality of the Seller’s services or Products, or any issues arising from services provided by third-party delivery service providers that do not meet User expectations, potentially resulting in loss, harm, or damage.
9.1.3. The no availability Products or services.
9.1.4. Incorrect Orders fulfilled by the Seller, or any liability associated with Products sold by the Seller.
 
9.2. The information about Products and the associated catalogue, including pricing, displayed on the Platform is provided by the Sellers. Kwik cannot be held liable for any changes, correctness or errors or omissions of the information, or unavailability of these Products and services.
‍
9.3. Kwik is not and cannot be a party to any transaction between You and Sellers or have any control, involvement or influence over the Products purchased/services availed by You from such Sellers. You acknowledge and agree that Kwik shall not, at any time, have any ownership, control, and/or title to any Product(s), which is subject to a bipartite sale and purchase transaction between You and the relevant Seller. Kwik does not provide any warranty or guarantee with respect to the Products and/or services offered for sale on the Platform and disclaims any liability with respect to the manufacturing defects, quality, taste, performance of the Products/services sold. All commercial and contractual arrangements regarding the Products and  services offered for sale are solely between Users and Sellers. These arrangements encompass various terms, including but not limited to pricing, product and service quality, applicable taxes, delivery and other fees, payment conditions, warranties (if any), and after-sales support. Kwik may, however, provide support services to Sellers in respect to Order fulfillment, mode of payment, payment collection, customer support, technology and other ancillary services, pursuant to independent contracts executed between Kwik and the Sellers.
 
9.4. Kwik does not guarantee or endorse the specifics of any Seller, including aspects like legal ownership, creditworthiness, or identity. We recommend that You conduct Your own due diligence to verify the legitimacy of any Seller You choose to engage with on the Platform and exercise Your discretion. All offers from Sellers and third parties are governed by their respective terms and conditions and Kwik assumes no responsibility for these offers.
 
9.5. You agree and understand that the Product images are representation of the Product and not actual image of the Product sold to You and You shall read the physical product label for the calorific and nutrition value, using instructions, batch, manufacture date, use by date/shelf life, content, weight, manufacturer and the customer support details, as may be relevant, before consumption of the Products including but not limited to Café orders. WHILE EVERY REASONABLE EFFORT IS MADE TO MAINTAIN ACCURACY OF INFORMATION ON THE PLATFORM, ACTUAL PRODUCT PACKAGING, MAY CONTAIN MORE AND/OR DIFFERENT INFORMATION THAN WHAT IS SHOWN ON THE PLATFORM. IT IS RECOMMENDED TO REFER THE INFORMATION PRESENTED ON THE ACTUAL PRODUCT PACKAGING.
 
9.6. Kwik reserves its right to refuse to process transactions by Users with a prior history of questionable transactions including without limitation breach of any agreements by User with Kwik or breach/violation of any law or any charges imposed by bank or breach of any policy without giving any reasons. Kwik may do such checks as it deems fit before approving the User's order for security or other reasons at the discretion of Kwik. As a result of such checks, if Kwik is not satisfied with the credibility of the User or genuineness of the transaction, it will have the right to reject the order/s placed by such Users or disable their access to the Platform. Transactions on the Platform may be delayed, suspended, or canceled at Kwik's sole discretion for any reason (to maintain the integrity, security, and equitable usage of the Platform), including but not limited to suspicious activities, concerns regarding the User's authenticity or behavior, unusually high transaction volumes, safety concerns, or to ensure the fair use of the Platform.
 
‍Beware of fraud:
 
9.7. Please do not share your debit/credit card number, CVV number, OTP, UPI/ATM pin and other sensitive information with anyone claiming to be a Kwik representative. Kwik or its authorized representatives will NEVER ask you to share the aforesaid details. Beware of fraudsters and please report incidents immediately to your bank, the nearest police station and at https://cybercrime.gov.in/.
 
9.8. For assistance on a Kwik order or refund related issues, click on the ‘Get Help’ section on the App.
 
9.9. Please exercise caution to verify the portals/website links claiming to be Kwik or a lookalike or a payment link shared over social media or a social messaging apps claiming to be Kwik discounts or offers and proactive calls from unauthorized numbers or unauthorized social media accounts requesting for personal/financial information.
 
10. Use of Platform
 
10.1. Subject to compliance with the Terms, Kwik hereby grants you a personal, non-exclusive, non- transferable, limited, revocable privilege to access and use the Platform. You agree to use the Platform only: (a) for purposes that are permitted by the Terms; (b) in accordance with any applicable law, regulation or generally accepted practices or guidelines; and (c) for availing the services through the Platform. You agree not to engage in activities that may adversely affect the use of the Platform by Kwik and/or other Users.
 
10.2. You agree that the Platform or any portion of the Platform shall not be reproduced, duplicated, copied, sold, resold or otherwise exploited for commercial purposes.
 
10.3. You agree to not frame or utilize the framing techniques to enclose any trademark, logo or any other proprietorship information of the Platform.
 
10.4. You agree not to access (or attempt to access) the Platform by any means other than through the interface that is provided by Kwik. You shall not use any deep- link, robot, spider or other automatic device, program, algorithm or methodology, or any similar or equivalent manual process, to access, acquire, copy or monitor any portion of the Platform or Content, or in any way reproduce or circumvent the navigational structure or presentation of the Platform, materials or any Content, to obtain or attempt to obtain any materials, documents or information through any means not specifically made available through the Platform.
 
10.5. Further, You undertake not to host, display, upload, modify, publish, transmit, store, update or share any information that:
 
10.5.1. belongs to another person and to which the User does not have any right;
10.5.2. is defamatory, obscene, pornographic, pedophilic, invasive of another's privacy, including bodily privacy, insulting, or harassing on the basis of gender, libelous, racially, or ethnically objectionable, relating or encouraging money laundering or gambling, or otherwise inconsistent with or contrary to the laws in force;
10.5.3. is harmful to child;
10.5.4. infringes any patent, trademark, copyright, or other proprietary rights;
10.5.5. violates any law for the time being in force;
10.5.6. impersonates another person;
10.5.7. threatens the unity, integrity, defense, security or sovereignty of India, friendly relations with foreign States, or public order, or causes incitement to the commission of any cognizable offence or prevents investigation of any offence or is insulting other nation;
10.5.8. Contains software virus or any other computer code, file or program designed to interrupt, destroy, or limit the functionality of any computer resource;
10.5.9. is patently false and untrue, and is written or published in any form, with the intent to mislead or harass a person, entity, or agency for financial gain or to cause any injury to any person;
10.5.10. disrupt or interfere with the security of, or otherwise cause harm to, the Platform, systems resources, accounts, passwords, servers, or networks connected to or accessible through the Platform or any affiliated or linked sites;
10.5.11. Violate the Terms contained herein or elsewhere; and
10.5.12. Reverse engineer, modify, copy, distribute, transmit, display, perform, reproduce, publish, license, create derivative works from, transfer, or sell any information or software obtained from the Platform.
 
10.6. You shall solely be responsible for maintaining the necessary computer equipment, gadgets and internet connections that may be required to access, use, and transact on the Platform.
 
10.7. You understand and acknowledge that by using the Platform or any of the services, you may encounter Content that may be deemed by some Users to be offensive, indecent, or objectionable, which Content may or may not be identified as such. You agree to use the Platform and any services at your sole risk and that to the fullest extent permitted under applicable law. Kwik shall have no liability to You for Content that may be deemed offensive, indecent, or objectionable to you.
 
11. Intellectual Property Rights
 
11.1. The Platform and the processes, and their selection and arrangement, including but not limited to, texts, videos, graphics, user interfaces, visual interfaces, sounds and music (if any), artwork and computer code (and any combinations thereof) (collectively, the “Content”)  on the Platform is either owned by or licensed by  Kwik  and the design, structure, selection, coordination, expression, look and feel and arrangement of such Content is protected by copyright, patent and trademark laws, and various other intellectual property rights.
 
11.2. The trademarks, logos and service marks displayed on the Platform (“Marks”) are the licensed property of Kwik or owned by third parties. You are not permitted to use the Marks without the prior consent of Kwik or the relevant third party (which is the owner of the Marks) respectively. Access or use of the Platform does not authorize any party to use trademarks, logo, or any other mark in any manner.
 
11.3. Kwik disclaims to hold any right, title, or interest in and to the intellectual property rights arising out of or associated with the Products and services sold by the Sellers on the Platform.
 
11.4. References on the Platform of any name, mark, services or products of third parties has been provided for your convenience, and in no way constitutes an endorsement, sponsorship or recommendation, whether express or implied.
 
11.5. Where Platform contains links to other sites provided by third parties, these links are provided for information only. We have no visibility or control over the contents on or available through those sites and you acknowledge and agree that we have no liability for any such content.
 
11.6. Kwik word mark and variances together with device marks displayed on the Platform shall be the licensed property of Us and any use, unless expressly permitted in writing shall amount to infringement and You shall hereby agree and undertake that You recognize Our intellectual property rights and upon acquiring knowledge of any infringement by any third parties, shall report to Us at legal@kwikgrocery.shop.
 
12. Disclaimer of Warranties & Liability
 
12.1. You expressly understand and agree that, to the maximum extent permitted by applicable law:
 
12.1.1. The Platform and other Content are provided by Kwik on an “as is” basis without warranty of any kind, express, implied, statutory, or otherwise, including the implied warranties of title, non-infringement, merchantability, or fitness for a particular purpose. Without limiting the foregoing, Kwik makes no warranty that the Platform or services will meet your requirements, or your use of the Platform will be uninterrupted, timely, secure, or error-free. No advice or information, whether oral or written, obtained by you from Kwik shall create any warranty not expressly stated in the Terms.
 
12.1.2. Kwik will not be liable for any loss that you may incur as a consequence of unauthorized use of Your Account or Account information in connection with the Platform either with or without your knowledge.
 
12.1.3. Kwik shall not nor is it obligated to mediate or resolve any disputes or disagreements that may arise between you and the Sellers. Kwik does not endorse either implicitly or explicitly, any sale or purchase of Products or services listed on the Platform. However, upon receiving a written request from you following the purchase of any Products and/or services on the Platform, Kwik may provide additional information about the Sellers involved in the transaction as available to facilitate direct communication between you and Sellers for the purpose of dispute resolution.
 
12.1.4. Kwik has endeavored to ensure that all the information on the Platform is accurate, but Kwik neither warrants nor makes any representations regarding the quality, accuracy or completeness of any data, information regarding the services or otherwise. Kwik shall not be responsible for the delay or inability to use the Platform or related functionalities, the provision of or failure to provide functionalities, or for any information, software, functionalities, and related graphics obtained through the Platform, or otherwise arising out of the use of the Platform, whether based on contract, tort, negligence, strict liability or otherwise. Further, Kwik shall not be held responsible for non-availability of the Platform during periodic maintenance operations or any unplanned suspension of access to the Platform that may occur due to technical reasons or for any reasons beyond Kwik’s reasonable control.
 
12.1.5. Colours of the Products displayed on the Platform are as accurately as possible. However, the actual colours of the Products You see will depend on your monitor or device, and we/Sellers do not provide any guarantee in respect of such display and will not be responsible or liable for the same
 
12.2. Kwik makes no representation that the Content on the Platform is appropriate to be used or accessed outside the Republic of India. Any Users who use or access the Platform from outside the Republic of India, do so at their own risk and are responsible for compliance with the laws of such jurisdiction and also consent to Kwik for use of their personal and other information only for the purpose of provision of services. By visiting the Platform or providing your information, you expressly agree to be bound by these Terms and Our Privacy Notice and also agree to be governed by the laws of India including but not limited to the laws applicable to data protection and privacy. If you do not agree please do not use or access our Platform.
 
12.3. The Terms do not constitute, nor may the Terms be used for or in connection with any promotional activities or solicitation by anyone in any jurisdiction in which such promotional activities or solicitation are not authorized or to any person to whom it is unlawful to promote or solicit.
 
12.4. Prices for any Product(s) displayed on the Platform may be inaccurate due to technical issues, typographical errors, or incorrect information provided by the Seller. In such cases, the Seller reserves the right to cancel the User’s Order(s).
 
12.5. Kwik accepts no responsibility for any breaches of applicable laws, including those governing the Products and services offered by Sellers or third-party delivery service providers or by payment gateway service providers.
 
12.6. You acknowledge that third-party services are available on the Platform, and we may partner with certain third parties to facilitate such services. However, you agree that we make no representations or warranties regarding these third-party services or products and will not be liable for any outcomes, including injury, impairment, or death, resulting from their use. You hereby waive any rights or claims you may have against us in relation to third-party services.
 
13. Indemnification and Limitation of Liability
 
13.1. You agree to indemnify, defend and hold harmless Kwik, Sellers, service providers, its officers, directors, consultants, agents, representatives and employees; and its third party partners (“Indemnities”) from and against any and all losses, liabilities, claims, damages, demands, costs and expenses (including reasonable legal fees) asserted against or incurred by the Indemnities that arise out of, result from, or may be payable by virtue of, any breach or non- performance of any representation, warranty, covenant or agreement made or obligation to be performed by You pursuant to these Terms and/or the Privacy Notice. Further, You agree to hold the Indemnities harmless against any claims made by any third party due to, or arising out of, or in connection with, Your use of the Platform, any misrepresentation with respect to the data or information provided by You, Your violation of the Terms and/or the Privacy Notice, Your violation of applicable laws, or Your violation of any rights of third parties, including any intellectual property rights.
 
13.2. In no event shall Kwik, its Sellers, its service providers and its directors, officers, partners, consultants, agents, and employees and its partners, be liable to You or any third party for any special, incidental, indirect, consequential, or punitive damages whatsoever, arising out of or in connection with Your use of or access to the Platform or Content on the Platform. Notwithstanding any provisions herein, Kwik, Sellers, service providers’ maximum total liability shall not exceed the amount paid by the User for the purchase of the Product and/or services under the specific order to which the liability relates.
 
13.3. The limitations and exclusions in this Section apply to the maximum extent permitted by applicable laws.
 
14. Violation of these Terms
 
14.1. You agree that any violation by You of these Terms will likely cause irreparable harm to Kwik, for which monetary damages would be inadequate and You consent to Kwik obtaining any injunctive or equitable relief that they deem necessary or appropriate in such circumstances. These remedies are in addition to any other remedies that Kwik may have at law or in equity.
 
15. Suspension and Termination
 
15.1. The Terms will continue to apply until terminated by either you or Kwik as set forth below. If you object to the Terms or are dissatisfied with the Platform, You may (i) close Your Account on the Platform; and/or (ii) stop accessing the Platform.
 
15.2. Kwik may disable Your access or block Your future access to the Platform or suspend or terminate Your Account if it believes, in its sole and absolute discretion, that You have violated any term of these Terms or the Privacy Notice or in any way otherwise acted unethically. Notwithstanding contained herein, all terms which by their nature are intended to survive such termination, will survive indefinitely unless and until Kwik chooses to terminate them.
 
15.3. Any such termination shall not cancel your obligation to pay for a Product or a service purchased on the Platform, or any other obligation which has accrued, or is unfulfilled and relates to the period, prior to termination.
 
15.4. You shall be liable to pay any fees or charges, if applicable in respect of the services until the date of termination by either party whatsoever.
 
16. Governing Law and Jurisdiction
 
16.1. These Terms shall be governed by and constructed in accordance with the laws of India without reference to conflict of laws principles and disputes arising in relation hereto shall be subject to the exclusive jurisdiction of courts at Bengaluru, India.
 
17. Grievance Redressal Mechanism
 
17.1.1. For any order related issue, you may first reach out to us via chat support on the App for real time basis resolution.
17.1.2. You may also write to us at support@kwikgrocery.shop and we will strive to resolve your order related issues within the timelines prescribed under applicable laws.
17.1.3. If You still have any grievances, or complaints or concerns with respect to the Platform or order or are not satisfied with the resolution, the Content, or the services, You can contact the designated Grievance cum Nodal Officer of Kwik as per the below details:
 
Mr. Arghyajit Lodh
Dodani
Address: Magnolia Oxygen A- II ROOM NO - ONE THOUSAND TWO KALABERIA,RAJARHAT POST OFFICE - RAJARHAT-BISHNUPUR PIN NO – 700135 Phone: 7219242614
Email: grievances@kwikgrocery.shop
Time: Mon – Sat (9:00 – 18:00) the aforementioned details of the Grievance cum Nodal Officer is provided incompliance of (1) Information Technology Act, 2000 and rules made there under, and (2) Consumer Protection (E-Commerce) Rules 2020, as amended time to time
 
17.2. The Grievance Officer of Kwik shall endeavor to acknowledge the User grievances, or complaints or concerns with respect to the Platform, the Content, or the services, within 48 hours of receipt of the same and shall endeavor to redresses the same at the earliest and in no event later than 30 (thirty) days of receipt of such request. By lodging a complaint or grievance, you agree to provide complete support to the Grievance Officer and such reasonable information as may be sought by them from You.
 
18. Notice of Infringement and Take Down Policy
 
18.1. Kwik’s Take Down Policy enables intellectual property owners to quickly report and remove infringing listings from the Platform.
 
18.2. Intellectual property owners can report potentially infringing Products or listings by submitting a Notice of Infringement containing all the details as mentioned below. Kwik cannot independently verify that Sellers have the rights to sell or distribute their Products or services but is fully committed to protecting intellectual property rights.
 
18.3. Steps to report a listing:
‍If you have a sincere belief that a Seller on Our Platform is infringing your intellectual property rights, please follow the below steps. We request you to provide the following information and email it to legal@kwikgrocery.shop. The email should include:
 
18.3.1. Identification or description of the copyrighted work/ trademark that has been infringed along with registration/application details and images.
18.3.2. Your contact information.
18.3.3. An undertaking from you that
 
a. You have a good faith belief that the use of the material complained of is not authorized by the trademark or copyright or intellectual property owner, its agent, or the law.
b. The information in the notice is accurate and that you are the trademark or copyright or intellectual property owner or authorized to act on the trademark or copyright or intellectual property owner's behalf.
 
18.3.4. Such other information that you think is important for supporting your claim.
 
18.4. Kwik’s actions
 
Upon receiving a duly completed notice with the necessary documentation as described above, and after confirming the authenticity of the claim, Kwik may take steps to remove or disable access to the alleged infringing content provided by third parties. Kwik may also inform the respective Seller who submitted the content in question, providing them with a copy of the infringement notice. We reserve the right to undertake any further actions as permitted by the applicable laws in effect at the time of notification.
 
19. Communications
 
19.1. You hereby expressly agree to receive communications by way of SMS, telephone or VOIP calls, messaging app like WhatsApp on the registered mobile phone number /or electronic communications like e-mails from Kwik and other third parties duly authorized by Kwik. You hereby expressly consent to the monitoring and recording, by Kwik and/or any third party of any and all communications between You and  Kwik  or its agents, employees, consultants, contractors, or representatives of Kwik or of their authorized partners, and such monitoring or recording waives any further notice or consent requirement under the applicable laws.
 
19.2. You can unsubscribe or opt-out from receiving promotional communications from Kwik. In which case, Kwik will only send communications solely required for the purposes of availing the services by you.
 
20. General Provisions
 
20.1. Notice: All notices from Kwik will be served by email to your registered email address or by messaging app on the registered mobile phone number or by general notification on the Platform.
 
20.2. Assignment: You cannot assign or otherwise transfer any rights granted hereunder to any third party. Kwik’s rights and obligations under the Terms are freely transferable by Kwik to its successor or to its affiliates or any third party without the requirement of seeking your consent.
 
20.3. Severability: If, for any reason any provision of the Terms, or any portion thereof, to be unenforceable, that provision shall be enforced to the maximum extent permissible so as to give effect to the intent of the parties as reflected by that provision, and the remainder of the Terms shall continue in full force and effect.
 
20.4. Force Majeure: Kwik, its Sellers, its service providers shall not be liable to You for its failure to perform or for delay in providing You access to Your Account or to the Platform or any services thereof, to the extent such failure or delay results from causes beyond its reasonable control, including, without limitation, acts of God, fires, explosions, wars or other hostilities, insurrections, revolutions, strikes, labour unrest, earthquakes, floods, riots, excessive rains, pandemic, epidemics or regulatory or quarantine restrictions, unforeseeable governmental restrictions or controls or a failure by a third party hosting provider or internet service provider or on account of any change or defect in the software and/or hardware of Your computer system.
 
21. Advertisements
 
21.1. As part of the services provided by Us, We may facilitate and allow third party advertisers (“Third Party Advertisers”) to place advertisements on the Platform. You understand that any content put out by Third Party Advertisers is not edited, reviewed or otherwise endorsed by Kwik and we disclaim to the fullest extent permitted by law any liability for the content published by the Third Party Advertisers. It is solely the responsibility of the Third Party Advertisers submitting material to the Platform to ensure compliance with all relevant laws. Any interactions or transactions you undertake with Third Party Advertisers found on the Platform including payments, delivery, and terms or representations related to their goods or services are strictly between you and the Third Party Advertiser. Kwik bears no liability for errors, omissions, or inaccuracies in advertising content or for any losses or damages arising from your dealings with these advertisers or their presence on the Platform.
 
21.2. To the extent you are a Third Party Advertiser You understand that in addition to these Terms You will also be required to agree to Kwik’s policies and other contractual agreements that you will need to execute for placing Your advertisement. As a general principle the content in the advertisements should not be misleading or in violation of applicable law or guidelines issued by the Advertising Standards Council of India or any other self-regulating body. You also acknowledge that  We have the sole right at  Our discretion to remove any Third Party Advertisement or require You to prove factual substantiation if We are of the view that it is in violation of applicable law or any self-regulating industry body guidelines or is otherwise misleading.
 
21.3. If you are of the view that the content of a Third Party Advertiser is inappropriate or in violation of applicable law, please write to Us at the email address provided above.
 
21.4. For any charitable campaign information shared with Users or displayed on the Platform, where donations may be made through third-party sites or accounts, Kwik may not be involved in fund collection or use. Kwik bears no responsibility for the accuracy or legality of campaign information, which is provided solely for reference. Users are encouraged to verify details independently before taking action.
 
22. Severability:
 
22.1. If any part of these Terms is found to be invalid, void, or unenforceable, that portion will be treated as separable, and the remaining provisions will continue in full force and effect.
 
23. Amendments:
 
23.1. We may modify these Terms periodically, without prior notice, to include updates, revisions, additions, or new policies affecting your use of the services. Such changes will be posted on the Platform and take effect immediately upon posting. We encourage you to review these Terms on the Platform regularly for any updates. By continuing to use the services and/or the Platform, You agree to accept any revised Terms.
 
24. Transition:
 
24.1. THE PLATFORM IS UNDERGOING A TRANSITION WHERE THE PLATFORM WILL BE OPERATED BY DODANI FROM THE DATE WHICH SHALL BE COMMUNICATED TO YOU. PURSUANT TO THE TRANSITION THE EXISTING USER OF KWIK SERVICES HERE BY CONSENT TO THE FOLLOWING:
 
24.1.1. FOR THE TRANSFER OF UNUSED FUNDS HELD IN YOUR WALLET BALANCE TO A KWIK GIFT CARD.
24.1.2. FOR THE TRANSFER OF YOUR PAYMENT RELATED INFORMATION AND INSTRUMENTS AS AVAILABLE WITH THE SERVICE PROVIDER OF KWIK TO ENSURE SEAMLESS EXPERIENCE FOR USERS POST TRANSITION.
 
23. Entire agreement:
 
23.1. This document, including the Privacy Notice and any policies that Kwik may introduce from time to time, represents the entire understanding between you and Kwik. It establishes the Terms for Your access to and use of the services and Platform superseding any earlier arrangements related to such access or use.
 
© 2025 Kwik, All rights reserved.
Privacy Policy
Terms of Use
Responsible Disclosure Policy
 
 
                        '''
                        });
                      },
                      child: Row(
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
                    ),
                    const DottedDivider(
                      height: 1,
                      color: Color.fromARGB(255, 211, 210, 210),
                      dashWidth: 10, // Length of each dash
                      dashSpace: 4, // Space between dashes
                    ),
                    InkWell(
                      onTap: () {
                        context.push(
                          '/privacy-policy',
                          extra: {
                            'privacyText': '''
Privacy Notice
Version 1.0
 
This Notice applies to Dodani Private Limited (hereinafter referred to as “Dodani” or “proprietorship firm”), a proprietorship firm is primarily registered under the Shop and Establishment Act and having its registered office at Magnolia Oxygen A- II ROOM NO - ONE THOUSAND TWO KALABERIA,RAJARHAT POST OFFICE - RAJARHAT-BISHNUPUR PIN NO – 700135 .The proprietorship firm is the owner of website https://www.kwikgrocery.shop/ and its mobile application ‘Kwik’ (collectively, the “Platform”).
 
This privacy notice (Privacy Notice) describes the policies and procedures applicable to the collection, use, storage, disclosure and protection of Your information shared with Us while You use the Platform, and for the purpose of this Privacy Notice "We", "Us", or "Our" refers to Kwik wherever context so require and the terms “You”, “Your”, “Yourself” or “User” refer to user of the Platform. We value the trust You place in Us. That is why, We maintain reasonable security standards for securing the transactions and Your information.
 
Please read the Privacy Notice carefully prior to using or registering on the Platform or accessing any material, information or availing any services through the Platform.
 
This Privacy Notice specifies the manner in which Your information is collected, received, stored, processed, disclosed, transferred, dealt with or otherwise handled by Us. This Privacy Notice does not apply to information that You provide to, or that is collected by, any third-party through the Platform, and any Third-Party Sites that You access or use in connection with the services offered on the Platform.
 
By visiting the Platform or setting up/creating an user account (Account) on the Platform, You accept and agree to be bound by the terms and conditions of this Privacy Notice and consent to Us collecting, storing, processing, transferring and sharing information including Your Personal Information (defined below) in accordance with this Privacy Notice.
 
Further, in case You are under the age of 18 years, You (i) accept and acknowledge that You are accessing the Platform through a parent or a legal guardian who is of a legal age to form a binding contract under the Indian Contract Act, 1872 and such person has accepted this Privacy Notice on Your behalf to bind You; and (ii) hereby acknowledge that You are accessing this Platform under the supervision of Your parent or legal guardian and have their express permission to use the services.
 
We may update this Privacy Notice in order to comply with the business or regulatory or administrative requirements. If We make any significant changes to this Privacy Notice, We may endeavour to provide You with reasonable notice of such changes, such as via prominent notice on the Platform or any other communication channels on record. To the extent permitted under applicable law, Your continued use of the services after We publish or send a notice about the changes to this Privacy Notice shall constitute Your consent to the updated Privacy Notice.
 
This Privacy Notice is incorporated into and subject to the terms of use available on the Platform (“Terms”) and shall be read harmoniously and in conjunction with the Terms. All capitalised terms used herein however not defined under this Privacy Notice shall have the meaning ascribed to them under the Terms.
 
1) Collection of Information: We collect various information from You when You access or visit the Platform, register or set up an Account on the Platform or use the Platform. You may browse certain sections of the Platform and the Content, without registering an Account on the Platform. However, to avail certain services on the Platform, You are required to set up an Account on the Platform. This Privacy Notice applies to information(s), as mentioned below and collected about You:
 
a) Personal Information: You may provide certain information to Us voluntarily while registering on the Platform for availing services including but not limited to Your complete name, mobile number, email address, date of birth, gender, age, address details, KYC related information such as Permanent Account Number (PAN), passport, driving licence, the voter's identity card issued by the Election Commission of India, or any other document recognized by the Government for identification, income details, Your business or professional details, videos or other online/ offline verification documents as mandated by relevant regulatory authorities, Your health and lifestyle related information and any other information voluntarily provided through the Platform, together with Your internet protocol address, web request, operating system, browser type, other browsing information (connection, speed, connection type etc.), device type, the device's telephone number (“Personal Information”). The act of providing Your Personal Information is voluntary in nature and We hereby agree and acknowledge that We will collect, use, store, transfer, deal with and share such details in compliance with applicable laws and this Privacy Notice.
 
b) Sensitive Personal Information: For the purpose of this Privacy Notice, Sensitive Personal Information consists of information relating to the following:
i) passwords;
ii) financial information such as bank account or credit card or debit card or other payment instrument details;
iii) physical, physiological and mental health condition;
iv) sexual orientation;
v) medical records and history;
vi) biometric information;
vii) any details relating to the above as provided to a body corporate for providing services; and
viii) any details relating to the above, received by a body corporate for processing, stored or processed under lawful contract or otherwise.
ix) any other information that may be regarded as Sensitive Personal Information” as per the prevailing law for the time being in force.
 
 
Provided that, any information that is freely available or accessible in public domain or furnished under the Right to Information Act, 2005 or any other law for the time being in force shall not be regarded as Personal Information or Sensitive Personal Information.
 
You may be asked for the payment details to process payments for the services. You may also be asked to provide certain additional information about Yourself on a case to case basis.
 
c) Transactional Information: If You choose to avail the services through the Platform, We will also collect and store information about Your transactions including transaction status, order history, number of transactions, details and Your behaviour or preferences on the Platform. All transactional information gathered by Us shall be stored on servers, log files and any other storage system owned by any of Us or by third parties. Your Short Messaging Service (SMS(es)) that are stored on Your device for the purposes of, including but not limited to, registering You and Your device for the purpose of Products and services, OTPs for logins, enhancing Your security are also collected and processed by Us
 
d) Location based information: When and if You download and/or use the Platform through Your mobile, tablet, and/or any other computer sources or electronic devices, We may receive information about Your location, Your IP address, internet bandwidth, mobile device model, browser plug-ins including a unique identifier number for Your device. The information You provide may be used to provide You with location-based services including but not limited to search results and other personalised content. If You permit the Platform to access Your location through the permission system used by Your device operating system, the precise location of Your device when the Platform is running in the foreground or background may be collected. You can withdraw Your consent at any time by disabling the location tracking functions on Your device. However, this may affect Your experience of certain functionalities on the Platform. In addition to the above, Your IP address is identified and used to also help diagnose problems with Our server, resolve such problems and administer the Platform. Your IP address is also used to help identify You and to gather broad demographic information.
 
The primary goal in doing so is to provide You a safe, efficient, smooth, and customised experience on the Platform. The information collected allows Us to provide the services and/or features on the Platform that most likely meet Your needs, and to customize the Platform to make Your experience safer and easier. More importantly, while doing so, We collect the abovementioned Personal Information from You that We consider necessary for achieving this purpose.
 
We may also collect certain non-personal information, such as URL, internet service provider, aggregate user data, software and hardware attributes, the URL of the previous website visited by You, list of third-party applications being used by You, pages You request, and cookie information, etc. which will not identify with You specifically, the activities conducted by You (“Non - Personal Information”), while You browse, access or use the Platform. We receive and store Non-Personal Information by the use of data collection devices such as “cookies” on certain pages of the Platform for various purposes, including authenticating Users, store information (including on Your device or in Your browser cache) about Your use of our services, remembering User preferences and settings, determining the relevancy of content, delivering and measuring the promotional effectiveness, and promote trust and safety, analyzing site traffic and trends, and generally understanding the online behaviors and interests of people. Certain additional features may be offered on the Platform that are only available through use of a “cookie”. We place both permanent and temporary cookies in Your device. We may also use cookies from third party partners for marketing and analytics purposes.
 
You are always free to decline such cookies if Your browser permits, although in that case, You may not be able to use certain features or services being provided on the Platform. Please refer to our Cookie Policy for additional details.
 
In general, You can browse the Platform without telling Us who You are or revealing any Personal Information about Yourself. In such a case, We will only collect and store the Non - Personal Information. Once You give Us Your Personal Information, You are not anonymous to Us. Wherever possible, while providing the information to Us, We indicate which fields are mandatory and which fields are optional for You. You always have the option to not provide the Personal Information to Us through the Platform by choosing to not use a particular Service or feature being provided on the Platform, which requires You to provide such information. We may automatically track certain information about You based upon Your behaviour on the Platform. We use this information to do internal research on Your demographics, interests, and behaviour to better understand, protect and prove service to You. This information is compiled and analysed by Us on an aggregated basis and not individually, in a manner that does not specifically identify You. If You choose to post messages on the Platform’s message boards, chat rooms or other message areas or leave feedback, We will collect and store such information You provide to Us. We retain this information as necessary to resolve disputes, provide customer support, respond to queries, and inquiries, and troubleshoot problems and improve the services.
 
If You send Us correspondence, such as emails or letters, or if other users or third parties send Us correspondence about Your activities or postings on the Platform, We may collect and retain such information into a file specific to You for responding to Your request and addressing concerns in relation to Your use of the Platform.
 
We shall be entitled to retain Your Personal Information and other information for such duration as may be required for the purposes specified hereunder and will be used only in accordance with this Privacy Notice
 
e) Additional Information: We may obtain information You voluntarily share with Us through interactions on Our social media channels, participation in surveys or by submission of feedback. Through these engagements and in order to provide the services You have accessed on Our Platform, We may also gain insights into certain Personal Information, such as Your preferences for Products and services.
 
You may also provide the information directly when You create an account on Our Platform or on phone or via chat with Us or when You provide any feedback to Us.
 
2) Use of information: We use the information in accordance with law, for the following:
 
a) to create Your account and verification of Your identity and access privileges
b)  to provide You the access to the Products and services offered by Us, Sellers, or business partners and improve the services on the Platform that You request;
c) for internal business purposes and services, including without limitation, warehousing services, delivery services, IT support services, and data analysis services;
d) to resolve disputes, to manage Your requests and complaints, administer Our service and diagnose/ troubleshoot technical problems;
e) to help promote a safe service on the Platform and protect the security and integrity of the Platform, the services and the users;
f) to design and improve the products and services and customer relationship management processes;
g) to collect money from You in relation to the services,
h) to inform You about online and offline offers, products, services, and updates;
i) to customize Your experience on the Platform or share marketing material with You;
j) to detect, prevent and protect Us from any errors, fraud and other criminal or prohibited activity on the Platform;
k) to enforce and inform about Our Terms of Use;
l) to process and fulfil Your request for services or respond to Your comments, and queries on the Platform;
m) to audit, monitor and enhance Our internal processes for smooth functioning of Our Platform and also to ensure effectiveness of internal procedures.
n) to contact You through email, SMS, WhatsApp, telephone and any other mode of communication in relation to the services;
o) to allow Our service providers, business partners and/or associates to communicate with You;
p) to allow third parties to contact You for Products and services availed/requested by You on Kwik Platform or third-party links
q) To identify and respond to security incidents and threats; to examine, prevent, and take corrective action against unlawful activities or suspected fraud, as part of audits or investigations carried out by Us or by regulatory authorities both within India and abroad.
r) to communicate important notices or changes in the services, use of the Platform and the Terms/policies which govern the relationship between You and Us, as applicable;
s) to conform to the legal requirements, compliance/reporting to regulatory authorities, as may be required and to comply with applicable laws;
t) to carry out Our obligations and enforce Our rights arising from any contract entered into between You and Us; and
u) to carry out research with relevant partners.
v) to carry out other legitimate business cases
w) to carry out marketing, advertising or promotional activities
x) for any other purpose after obtaining Your consent at the time of collection
 
(collectively “Purposes”).
 
We may occasionally ask You to complete optional online surveys. These surveys may ask You for Your contact information and demographic information (like pin code, or age), Your income details, Your business or Profession or other information. We use this information to tailor Your experience on the Platform, providing You with content that We think You might be interested in and to display content according to Your preferences. We use Your information to send You personalized offers, and newsletters through various channels such as email/WhatsApp/SMS/RCS/push notification or any other channel for Our marketing and promotional purposes. s, however, We You have the the ability to opt-out of receiving such communications from Us. However, You will not be able to opt- out of receiving administrative messages, customer service responses or other transactional communications. We will not share Your Personal Information with another user of the Platform and vice versa without Your express consent. In accordance with applicable laws, We may monitor or record Your phone conversations or chats for training, customer service enhancement, legal compliance or to establish and defend legal claims. If We are required by law or by the terms of Our contract with You to collect specific Personal Information and You do not provide it when requested, We may where legally permissible be unable to fulfill Our contract with You (for example, providing You with access to Our Platform and related services).
 
3) Sharing of Information:
 
a) Business Partners: We may disclose Your Personal Information to third party Sellers, service providers, merchants, delivery partners, marketing or advertising partners, consultants, partners for carrying out research and other service providers who work for either of Us or provide services through the Platform. This disclosure may be required, for instance, to provide You access to the services and process payments including validation of Your Payment Details, to facilitate and assist marketing and advertising activities/initiatives, for undertaking auditing or data analysis, or to prevent, detect, mitigate, and investigate fraudulent or illegal activities related to the services. You expressly consent to the sharing of Your information with third party service providers, including payment gateways, to process payments and manage Your payment-related information.
 
b) Compliance with law: We may disclose Your information including Personal Information, to the extent necessary: (a) to comply with laws, regulatory requirements and to respond to lawful requests and legal process or an investigation, (b) to protect Our rights and property, the users, and others, including to enforce the Terms or to prevent any illegal or unlawful activities, and (c) in an emergency to protect Our personal safety and assets the users, or any person. In all such events We shall in no manner be responsible for informing You or seeking Your approval or consent. We may also share aggregated anonymized (and de-identified) information with third parties at Our discretion.
 
c) Acquisition Sale or Merger: We may, in compliance with applicable laws, share all of Your Personal Information (including Sensitive Personal Information) and other information with any other business entity(ies), in the event of a merger, sale, reorganisation, amalgamation, joint ventures, assignment, restructuring of business or transfer or disposition of all or any portion of any of Us.
 
d) Sharing of information with any member of Our Group or affiliated entities, third parties and transfer outside India: Subject to applicable law, We may at Our sole discretion, share Personal Information (including Sensitive Personal Information) to Our Group or affiliated entities, any third party that ensures at least the same level of data protection as is provided by Us under the terms hereof, located in India or any other country. By using the Platform, You accept the terms hereof and hereby consent to Us, sharing of Your Personal Information and Sensitive Personal Information to Our Group or affiliated entities, third parties, including in any location outside India, The Personal Information We process may be transferred to countries outside Your current location. For instance, We may transfer Your information to locations where some of Our Service Providers/Processors are based. For further details on these transfer mechanisms, You may reach out to Us. For the purpose of this clause the term “Group” shall mean, with respect to any person, any entity that is controlled by such person, or any entity that controls such person, or any entity that is under common control with such person, whether directly or indirectly, including any Relative or Related Party (as such term defined in the Companies Act, 2013 to the extent applicable) of such person, holding, subsidiary Companies, etc.
 
You also specifically agree and consent to Us collecting, storing, processing, transferring, and sharing information (including Personal Information and Sensitive Personal Information) related to You with third parties such as with entities registered under applicable laws including payment gateways and aggregators, solely for Us to provide services to You including processing Your transaction requests for the services or to improve Your experience on the Platform.
‍
While We may share Your Personal Information and Sensitive Personal Information with third parties, including regulatory bodies, governmental authorities and financial institutions, We are committed to enforcing equal or more stringent privacy protection obligations with these third parties, wherever applicable and feasible. We take reasonable measures to ensure these third parties process information in accordance with Our Privacy Notice though processing and protection ultimately fall under the governance of their policies and applicable laws. As such, We disclaim responsibility or liability for these third parties' handling of Your information.
 
4) Security Precautions and Measures: The Platform has reasonable security measures and safeguards in place to protect Your privacy and Personal Information from loss, misuse, unauthorized access, disclosure, destruction, and alteration, in compliance with applicable laws. Further, whenever You change or access Your Account on the Platform or any information relating to it, the use of a secure server is offered. It is further clarified that You have and so long as You access and/or use the Platform (directly or indirectly) the obligation to ensure that You shall at all times take adequate physical, managerial, and technical safeguards, at Your end, to preserve the integrity and security of Your information which shall include and not be limited to Your Personal Information.
 
You will be responsible for maintaining the confidentiality of the Account information and are fully responsible for all activities that occur under Your Account. You agree to (a) immediately notify Us of any unauthorised use of Your Account information or any other breach of security, and (b) ensure that You exit from Your Account at the end of each session. We cannot and will not be liable for any loss or damage arising from Your failure to comply with this provision. You may be held liable for losses incurred by any of Us or any other user of or visitor to the Platform due to authorised or unauthorised use of Your Account as a result of Your failure in keeping Your Account information secure and confidential. Additionally, You are responsible for keeping Your login ID and password confidential and secure. Please avoid sharing Your login credentials, password or OTP with anyone. It is Your responsibility to promptly inform Us of any actual or suspected compromise of Your Personal Information.
 
When payment information is being transmitted on or through the Platform, it will be protected by encryption technology. Hence, We cannot guarantee that transmissions of Your payment-related information or Personal Information will always be secure or that unauthorized third parties will never be able to defeat the security measures taken by Us or Our third-party service providers. We assume no liability or responsibility for disclosure of Your information due to errors in transmission, unauthorised third-party access, or other causes beyond Our control. You play an important role in keeping Your Personal Information secure. You shall not share Your Personal Information or other security information for Your Account with anyone. We have undertaken reasonable measures to protect Your rights of privacy with respect to Your usage of the Platform and the services. However, We shall not be liable for any unauthorised or unlawful disclosures of Your Personal Information made by any third parties who are not subject to Our control.
 
Notwithstanding anything contained in this Privacy Notice or elsewhere, We shall not be held responsible for:
 
a) any security breaches on third-party websites or applications or for any actions of third-parties that receive Your Personal Information; or
 
b) any loss, damage or misuse of Your Personal Information, if such loss, damage or misuse is attributable to a Force Majeure Event. For the purpose of this Privacy Notice, a “Force Majeure Event” shall mean any event that is beyond Our reasonable control and shall include, acts of God, fires, explosions, wars or other hostilities, insurrections, revolutions, strikes, labour unrest, earthquakes, floods, pandemic, epidemics or regulatory or quarantine restrictions, unforeseeable governmental restrictions or controls or a failure by a third party hosting provider or internet service provider or on account of any change or defect in the software and/or hardware of Your computer system.
 
5) Retention of Your Personal Information: We maintain records of Your Personal Information only till such time it is required for the Purposes, or for as long as required by applicable law. To the extent possible, We endeavour to store Personal Information and Sensitive Personal Information within India. When You request Us to erase Your information, We will honour the said request, but We may retain certain information about You for the purposes authorized under this Privacy Notice unless prohibited by law.  However, We may retain Your Personal Information if We believe it may be necessary to prevent fraud or future abuse, to enable Us to exercise legal rights and/or defend against legal claims.
 
6) Links to Other Third – Party Sites and collection of information: The Platform may link You to other third - party platforms (“Third - Party Sites”) that may collect Your Personal Information including Your IP address, browser specification, or operating system. We are not in any manner responsible for the security of such information or their privacy practices or content of those Third - Party Sites. Additionally, You may also encounter “cookies” or other similar devices on certain pages of the Third - Party Sites and it is hereby clarified that the Platform does not control the use of cookies by these Third - Party Sites. These third-party service providers and Third-Party Sites may have their own privacy policies governing the storage and retention of Your information that You may be subject to. This Privacy Notice does not govern any information provided to, stored on, or used by these third-party providers and Third-Party Sites. We recommend that when You enter a Third-Party Site, You review the Third-Party Site’s privacy policy as it relates to safeguarding of Your information and that the Third-Party Site’s privacy policy is beyond our control. We may use third-party advertising entities to serve ads when You visit the Platform. These entities may use information (not including Your name, address, email address, or telephone number) about Your visits to the Platform and Third- Party Sites in order to provide advertisements about goods and services of interest to You. You agree and acknowledge that We are not liable for the information published in search results or by any Third-Party Sites.
 
8) Public Posts: You may provide Your feedback, reviews, testimonials, etc. on the Platform on Your use of the services (“Posts”). Any content or Personal Information and Posts that You share or upload on the publicly viewable portion of the Platform (on discussion boards, in messages and chat areas, etc.) will be publicly available, and can be viewed by other users and any and all intellectual property rights in and to such Posts shall vest with Us. Your Posts shall have to comply with the conditions relating to Posts as mentioned in the Terms. We shall retain an unconditional right to remove and delete any Post or such part of the Post that, in Our opinion, does not comply with the conditions in the Terms or where applicable law requires Us to remove such Post. We reserve the right to use, reproduce and share Your Posts for any purpose. If You delete Your Posts from the Platform, copies of such Posts may remain viewable in archived pages, or such Posts may have been copied or stored by other Users.
 
8) Your Consent, Rights and Changes to Privacy Notice:‍
 
Your Consent: All information disclosed by You shall be deemed to be disclosed willingly and without any coercion. No liability pertaining to the authenticity / genuineness / misrepresentation / fraud / negligence of the information disclosed shall lie on Us nor will We be in any way responsible to verify any information obtained from You.  We process Your Personal Information based on Your consent. By using the Platform or services and/or providing Your Personal Information, You agree to the processing of Your data in accordance with this Privacy Notice. If You share any Personal Information about others with Us, You confirm that You have the necessary authority to do so and allow us to use that information as outlined in this Privacy Notice. Additionally, You consent to Us contacting You via channels such as phone calls, messages, and emails for the purposes described in this Notice, regardless of Your registration with any Do Not Disturb (DND) lists.
 
Right to erasure and Right to Withdraw Your consent: You may choose to withdraw Your consent provided hereunder at any point in time. You may do the same by visiting Home page ->Settings Icon -> Profile on the mobile application.
 
In case You do not provide Your consent or later withdraw Your consent, We request You not to access the Platform, Content or use the services. We shall also cease to provide You any services and/or Content on the Platform and/or features of the Platform once You withdraw Your consent. In such a scenario, We will remove Your information (personal or otherwise) or de-identify it so that it is anonymous and not attributable to You. In the event, We retain the Personal Information post withdrawal or cancellation of Your consent, it shall retain it only for the period permitted under applicable laws. You shall have the right to request that We remove Your Personal Information from Our systems.
 
You should be aware that some of the Personal Information that may have been shared on third-party websites may still continue to be available as We do not have control over these websites. Your Personal Information may also appear in online searches. Other Personal Information that You have shared with others, or that other users have copied, may also remain visible. You should only share Personal Information with people that You trust because they will be able to save it or re-share it with others, including when they sync the Personal Information to a device.
 
Personal Information access, Rectification or Modification of Your information: You can access and review Your Personal Information shared by You by placing a request with Us. You may review, correct, complete, upgrade, erase, update and change the information that You have provided to Us, at any point by making changes on the mobile application Home page ->Settings Icon -> Profile. Should You choose to update Your Personal Information or modify it in a way that is not verifiable by Us, or leads to such information being incorrect, We will be unable to provide You with access to the Platform or the services. We reserve the right to verify and authenticate Your identity and Your Personal Information in order to ensure that We are able to offer You services and/or make available the Platform. We can only keep Your Personal Information up-to-date and accurate to the extent You provide Us with the necessary information. It is Your responsibility to notify Us of any changes in Your Personal Information. Access to or correction, updating or erasing of Your Personal Information may be denied or limited by Us if it would violate another person’s rights and/or is not otherwise permitted by applicable law.
 
Right to nominate another person: You have the right to nominate one or more individuals to act on Your behalf in case of Your death or incapacity to exercise applicable rights.
 
Right to restrict Our use of Your Personal Information: You have the right to object or limit the way in which We can use or process Your Personal Information.
 
Right to complain to supervisory authorities: If You wish to make a complaint or are unhappy with the way We process Your Personal Information, You have the right to complain to the appropriate supervisory authority of Your jurisdiction. However, We would suggest to first utilize Our grievance redressal mechanism before reaching out to the supervisory authorities.
 
Children Information
 
We are deeply committed to safeguarding the privacy of minors and ensuring compliance with applicable laws pertaining to the collection and processing of the Personal Information of the children. We do not intentionally gather or request Personal Information from individuals under the age of 18. Our Platform is intended solely for those who are legally capable of entering into contracts as per the Indian Contract Act, 1872. If You have not reached the age of 18, You are prohibited from using the Platform unless supervised by Your parent or legal guardian. If We become aware that a child under the age of 18 has given their Personal Information, We reserve the right to stop the access to the Platform.
 
Changes to Our Privacy Notice: We reserve the unconditional right to change, modify, add, or remove portions of this Privacy Notice at any time, and shall provide a notice to You of such changes. Any changes or updates will be effective immediately. You should review this Privacy Notice regularly for changes. You can determine if changes have been made by checking the “Last Updated” legend above. Your acceptance of the amended Privacy Notice by  continuing to visit the Platform or using the services, shall signify Your consent to such changes and agreement to be legally bound by the same.
 
9. Grievance Officer:
 
We have appointed a grievance officer, under authorisation, in accordance with the Information Technology Act, 2000 and the rules made thereunder, for the purpose of redressing any grievances or complaints You may have regarding the handling of Your Personal Information. You can contact the designated Grievance Officer for the purpose of this Privacy Notice, namely, xyz, at legal@kwikgrocery.shop. We are committed to answer Your questions within the reasonable time limit. Any delay in the resolution time shall be proactively communicated to You. If You suspect any misuse or loss or unauthorized access to Your Personal Information please let Us know immediately.
 
10. Questions?
 
Please feel free to contact at this legal@kwikgrocery.shop regarding any questions on the Privacy Notice. We will use reasonable efforts to respond promptly to requests, questions or concerns You may have regarding Our use of Your Personal Information. Except where required by law, We cannot ensure a response to questions or comments regarding topics unrelated to this Privacy Notice or the privacy practices specified herein.
 
 
© 2025 https://www.kwikgrocery.shop/, All rights reserved.
 
Cookie Policy
 
 
Version 1.0
 
This Cookie Policy ("Policy") is incorporated into and forms an integral part of Our Privacy Notice and Terms of Use. Any capitalized terms mentioned in this Policy but not explicitly defined here shall carry the meanings ascribed to them in the Privacy Notice.
 
About cookies
 
Cookies are small text files placed on Your browser or device by websites, apps, online media, and advertisements. There are various types of cookies. Cookies set by the domain You are visiting are known as “first-party cookies.” For example, cookies set by Kwik while You browse the Platform are first-party cookies. In contrast, cookies set by other companies on the domain You are visiting are referred to as “third-party cookies.” For instance, if Google sets a cookie on Your browser while You are visiting the Platform, that would be a third-party cookie. Cookies also differ in their duration. “Session cookies” are temporary and last only while Your browser is open, automatically deleted when the browser is closed. On the other hand, “persistent cookies” remain on Your device after the browser is closed and can recognize Your device upon reopening.
 
Purpose of using Cookies?
 
We utilize cookies and other identification technologies for several purposes, including authenticating users, storing information about You (on Your device or in Your browser cache), tracking Your usage of Our services and the Platform, remembering user preferences and settings, assessing the popularity of content, delivering and evaluating the effectiveness of advertising campaigns, analyzing site traffic and trends, and gaining insights into the online behaviors and interests of individuals who avail Our services. Following are the indicative list of cookies and Kwik retain the right to utilize similar and other cookies for the purpose specified hereinbelow:
‍
 
Category
Description
Strictly Necessary cookies
These cookies are necessary in order to enable You to access the website and its features and to provide services to You.
Performance Cookies
These cookies allow Us to employ data analytics so We can measure and improve the performance of Our website and provide more relevant content to You. We and Our partners may use these cookies to improve and understand Your usage of the Products and services.
Functionality Cookies
These cookies allow a site to remember choices You make (such as Your username, language or the region You are in) and provide more enhanced, personal features. These cookies cannot track Your browsing activity on other websites. They don’t gather any information about You that could be used for advertising or remembering where You have been on the Internet outside Our site.
Security cookies
These cookies are used to enable security features to help Kwik safe and secure.
Advertising and social media cookies
Advertising and social media cookies (including web beacons and other tracking and storage technologies) are used to (1) deliver advertisements more relevant to You and Your interests; (2) limit the number of times You see an advertisement; (3) help measure the effectiveness of the advertising campaign; (4) re-targeting to kwik websites/information and (5) understand people’s behavior after they view an advertisement. They remember that You have visited a site and quite often they will be linked to website functionality provided by the other organization. This may impact the content and messages You see on other websites You visit.
Do We use Third Party Cookies?
 
We engage various service providers who may set cookies on Your device on Our behalf when You visit the Platform, enabling them to provide the services they offer. Additionally, when You visit the Platform, You may receive cookies from third-party websites or domains. Further information regarding these cookies can typically be found on the respective third party’s website.
 
Additional Information About Third Party Analytics in use on Our Platform:
‍
Facebook Connect. For more information on how Facebook collect and use information on Our behalf, please see: facebook privacy policy.
 
Instagram: For more information on how Instagram collect and use information on Our behalf, please see: https://privacycenter.instagram.com/policies/cookies/
 
X. For more information on how X collect and use information on Our behalf, please see: X privacy policy
 
Google Analytics: For more information about Google Analytics cookies, please see Google's help pages and privacy policy:
 
Google Privacy Policy
 
Google Analytics web pages
 
How can I control Cookie Preferences?
 
Most internet browsers are initially configured to automatically accept cookies. However, You can modify Your settings to block cookies or to notify You when cookies are sent to Your device. There are several methods available to manage cookies. For more details on how to adjust or modify Your browser settings, please consult Your browser's instructions or help section.
 
Disabling the cookies We use may affect Your experience on the Platform. For instance, certain areas of the Platform may become inaccessible, You may not receive personalized content, or You may be unable to log in to specific services or programs, such as forums or accounts.
 
If You use multiple devices to access the Platform (e.g., a computer, smartphone, tablet), You will need to ensure that each browser on each device is set according to Your cookie preferences.
 
Cookie Preferences. The browser settings for changing Your cookies settings are usually found in the 'options' or 'preferences' menu of Your internet browser. In order to understand these settings, the following links may be helpful. Otherwise, You should use the 'Help' option in Your internet browser for more details.
 
Internet Explorer
Firefox
chrome
Microsoft Edge
 
More information. To find out more about cookies, including how to see what cookies have been set and how to manage and delete them, visit About Cookies.
 
Local storage is a technology enabling websites or apps to store data locally on Your device. “Software Development Kits” (SDKs) function similarly to pixels and cookies but operate within mobile apps, where traditional cookies and pixels may not work. App developers can integrate SDKs from partners into their apps, allowing partners to collect information about user interactions, device details, and network data. “Pixel tags” (also called beacons or pixels) are small code snippets embedded in webpages, apps, or advertisements. They collect information about Your device and browser, such as device type, operating system, browser version, the webpage visited, time of visit, referring website, IP address, and other similar details, including cookies that uniquely identify users.
 
© 2025 Kwik, All rights reserved.
Privacy Policy
Terms of Use
''',
                          },
                        );
                      },
                      child: Row(
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
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  HapticFeedback.mediumImpact();
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    enableDrag: false,
                    context: context,
                    builder: (context) {
                      return GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: const LogoutBottomSheet(),
                        ),
                      );
                    },
                  );
                },
                child: Container(
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
                          Icons.logout_outlined,
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
