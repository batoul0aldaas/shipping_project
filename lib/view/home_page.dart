
import 'package:ba11/view/home_content.dart';
import 'package:ba11/view/shipment-view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_page_controller.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_drawer.dart';
import 'cart_view.dart';
import 'notifications_view.dart';
import 'orders_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomePageController());

    final pages = [
      const HomeBody(),
      const OrdersView(),
      const CartView(),
      const NotificationsView(),
    ];

    return Obx(() => Scaffold(

      body: IndexedStack(
        index: controller.selectedIndex.value,
        children: pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: controller.selectedIndex.value,
        onTap: (index) => controller.selectedIndex.value = index,
        onCenterTap: () {
          Get.defaultDialog(
            title: 'طلب شحنة جديدة',
            middleText: 'هل تريد انشاء شحنة ؟؟.',
            textConfirm: 'حسنًا',
            confirmTextColor: Colors.white,
            buttonColor: const Color(0xFF334EAC),
            onConfirm: () {
               Get.to(() => ShipmentView());
            },
          );
        },
      ),
    ));
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title:  Text(
          'title'.tr,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF667EEA),
                Color(0xFF764BA2),
              ],
            ),
          ),
        ),
      ),
      drawer:CustomDrawer(),
      body: const HomeContent(),
    );
  }
}
