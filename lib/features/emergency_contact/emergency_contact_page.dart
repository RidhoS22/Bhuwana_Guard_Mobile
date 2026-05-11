import 'package:flutter/material.dart';

class EmergencyContactPage extends StatelessWidget {
  final String fromPage;

  const EmergencyContactPage({
    super.key,
    required this.fromPage,
  });

  @override
  Widget build(BuildContext context) {
    const darkGreen = Color(0xFF154E39);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 18,
          ),

          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          "Emergency Contact",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 800,
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 30,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// LOCATION
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),

                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),

                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,

                        decoration: const BoxDecoration(
                          color: Color(0xFFFFE6E6),
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Text(
                          "Desa kertosono, Kecamatan kertoyani",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: Color(0xFF154E39),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// NEAREST CALL
                Container(
                  width: double.infinity,
                  height: 64,

                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                    ),

                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: [
                        const Text(
                          "Nearest Emergency Call",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        Container(
                          width: 42,
                          height: 42,

                          decoration: const BoxDecoration(
                            color: Color(0xFFC50000),
                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.call,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Callable Options",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2.8,

                    children: const [
                      EmergencyCard(title: "Police"),
                      EmergencyCard(title: "Ambulance"),
                      EmergencyCard(title: "Fire Dept"),
                      EmergencyCard(title: "Basarnas"),
                      EmergencyCard(title: "Karhutla"),
                      EmergencyCard(title: "EFRP"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmergencyCard extends StatelessWidget {
  final String title;

  const EmergencyCard({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),

      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),

        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Color(0xFF154E39),
              fontWeight: FontWeight.w500,
            ),
          ),

          Container(
            width: 34,
            height: 34,

            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
              ),

              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.call,
              color: Colors.red,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}