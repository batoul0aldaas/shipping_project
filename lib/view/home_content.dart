import 'package:ba11/controller/shipment-controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_page_controller.dart';

class HomeContent extends StatelessWidget {
  // 🟦 خريطة التصنيفات مع أيقونة + لون
  static const  Map<String, Map<String, dynamic>> categoryStyles = {
    "توصيل داخلي": {
      "icon": Icons.location_city,
      "color": Colors.blue,
    },
    "توصيل دولي": {
      "icon": Icons.flight_takeoff,
      "color": Colors.green,
    },
    "نقل مبرد": {
      "icon": Icons.ac_unit,
      "color": Colors.cyan,
    },
    "شحن بضائع": {
      "icon": Icons.inventory_2,
      "color": Colors.orange,
    },
    "توصيل مستندات": {
      "icon": Icons.description,
      "color": Colors.indigo,
    },
    "شحن إلكترونيات": {
      "icon": Icons.devices,
      "color": Colors.deepPurple,
    },
    "توصيل شخصي": {
      "icon": Icons.person,
      "color": Colors.pink,
    },
    "توصيل ليلي": {
      "icon": Icons.nightlight_round,
      "color": Colors.teal,
    },
    "توصيل شركات": {
      "icon": Icons.business,
      "color": Colors.brown,
    },
  };
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShipmentController());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage("assets/images/10.jpg"),
                fit: BoxFit.cover,
                opacity: 0.09,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "مرحبًا بك 👋",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "Mada",
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "ابحث عن أفضل حلول الشحن بسهولة وسرعة",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontFamily: "Mada",
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ====== التصنيفات ======
          Text("التصنيفات",
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Mada')),
          const SizedBox(height: 12),

          Obx(() {
            if (controller.categories.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  final style = categoryStyles[category.name] ??
                      {"icon": Icons.category, "color": Colors.grey};

                  return Container(
                    width: 130,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (style["color"] as Color).withOpacity(0.1),
                          Colors.white
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: (style["color"] as Color).withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor:
                          (style["color"] as Color).withOpacity(0.15),
                          radius: 26,
                          child: Icon(style["icon"] as IconData,
                              color: style["color"] as Color, size: 28),
                        ),
                        const SizedBox(height: 10),
                        Text(category.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                },
              ),
            );
          }),

          const SizedBox(height: 20),


          // ====== عملاؤنا ======
          Text("عملاؤنا",
              style: const TextStyle(fontSize: 35, fontWeight: FontWeight.normal,fontFamily: 'Mada' )),
          const SizedBox(height: 12),

          SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                clientCard(
                  logo: "https://speedone.co/wp-content/uploads/2024/08/Untitled-design-1536x344.png",
                  name: "Speedex Logistics Import & Export Limited Şirketi",
                  address: "Şair Nigar Sk. No: 41/5 Osmanbey/İstanbul",
                  phone: "+90 (212) 219 99 95",
                  email: "info@speedexlogistic.com",
                ),
                clientCard(
                  logo: "https://speedone.co/wp-content/uploads/2024/08/Cr-empire-logo-01-2048x1509.png",
                  name: "Creativity Empire General Trading LLC",
                  address: "Sheikh Zayed Rd Dubai Rawdat Al Wasel Building Office, 111 Dubai, UAE",
                  phone: "+971 4338 23333",
                  email: "info@cr-empire.com",
                ),
                clientCard(
                  logo: "https://speedone.co/wp-content/uploads/2024/08/Bawabet-alnokhbeh-logo-01-2048x1509.png",
                  name: "Bawabet Alnokhba Import & Export Co.",
                  address: "Building 33, Alhosain Cinema Avenue, King Ghazi Street, Downtown, Amman, Jordan",
                  phone: "+962 795446000",
                  email: "mohannad@abuhinda.com",
                ),
                clientCard(
                  logo: "https://speedone.co/wp-content/uploads/2024/08/Untitled-1-01-removebg-preview.png",
                  name: "BYKO AGENCY",
                  address: "Al-rawabi - Mecca Street, Amman - Jordan",
                  phone: "+962-770 2000 25",
                  email: "info@bykoagency.com",
                ),
                clientCard(
                  logo: "https://speedone.co/wp-content/uploads/2024/08/world-continents-logo-01-2048x1124.png",
                  name: "World Continents Import & Export Co.",
                  address: "2nd floor - 42 complex - Swefieh, Amman - Jordan",
                  phone: "+962 6 5519625",
                  email: "info@world-continents.com",
                ),
                clientCard(
                  logo: "https://speedone.co/wp-content/uploads/2024/08/Al-madaen-logo-01-2048x1509.png",
                  name: "Al MADAEN Forwarding & Clearance Goods",
                  address: "136 complex - Abd Alraheem Alhaj, Mohammad Street - Swefieh, Amman - Jordan",
                  phone: "+962 79 588 7098",
                  email: "madaencom@yahoo.com",
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // ====== الأسئلة الشائعة ======
          Text("الأسئلة الأكثر شيوعًا",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal,fontFamily: 'Mada' )),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              faqCard("كيف أتابع شحنتي؟"),
              faqCard("ما هي طرق الدفع المتاحة؟"),
              faqCard("كم تستغرق مدة التوصيل؟"),
              faqCard("هل يمكن تعديل عنوان الشحن؟"),
            ],
          ),



        ],
      ),
    );
  }

  Widget faqCard(String question) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF667EEA).withOpacity(0.15),
            const Color(0xFF764BA2).withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF667EEA).withOpacity(0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.help_outline_rounded,
              color: Color(0xFF667EEA), size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              question,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: 'Mada',
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget clientCard({
    required String logo,
    required String name,
    required String address,
    required String phone,
    required String email,
  }) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Image.network(logo, height: 50, fit: BoxFit.contain)),
          const SizedBox(height: 10),
          Text(name,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(address, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Text("📞 $phone", style: const TextStyle(fontSize: 12)),
          Text("✉️ $email", style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

}



