import 'package:flutter/material.dart';
import '../emergency_contact/emergency_contact_page.dart';

class SafetyGuidePage extends StatelessWidget {
  const SafetyGuidePage({super.key});

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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Safety Guide",
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Facing Wildlife",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 25),

          _buildRiskTile(
            context,
            title: "Low Risk",
            subtitle: "Condition : Harmless Animal",
            page: const LowRiskPage(),
          ),

          _buildRiskTile(
            context,
            title: "Medium Risk",
            subtitle: "Condition : Animals can attack if threatened",
            page: const MediumRiskPage(),
          ),

          _buildRiskTile(
            context,
            title: "High Risk",
            subtitle:
                "Condition : animals has the potential to cause serious harm",
            page: const HighRiskPage(),
          ),

          _buildRiskTile(
            context,
            title: "Extreme Risk",
            subtitle: "Condition : Already attacking",
            page: const ExtremeRiskPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget page,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: InkWell(
        borderRadius: BorderRadius.circular(14),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },

        child: Container(
          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(14),
          ),

          child: Row(
            children: [
              const Icon(Icons.arrow_forward_ios, size: 16),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LowRiskPage extends StatelessWidget {
  const LowRiskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RiskDetailPage(
      title: "Low Risk",
      subtitle: "Facing Non-Dangerous Wildlife",
      image: "assets/images/cow.png",

      steps: [
        {
          "step": "Step 1",
          "title": "Stay Calm",
          "desc": "Observe from a safe distance."
        },
        {
          "step": "Step 2",
          "title": "Observe Only",
          "desc": "Do not approach or touch the animal."
        },
        {
          "step": "Step 3",
          "title": "Do Not Feed",
          "desc":
              "Avoid feeding as it may change the animal's behavior."
        },
        {
          "step": "Step 4",
          "title": "Keep Environment Natural",
          "desc": "Let the animal stay in its natural habitat without disturbance."
        },
      ],
    );
  }
}

class MediumRiskPage extends StatelessWidget {
  const MediumRiskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RiskDetailPage(
      title: "Medium Risk",
      subtitle: "Facing Potentially Aggressive Wildlife",
      image: "assets/images/monkey.png",

      steps: [
        {
          "step": "Step 1",
          "title": "Stay Calm",
          "desc": "Observe from a safe distance."
        },
        {
          "step": "Step 2",
          "title": "Keep Your Distance",
          "desc": "Maintain a distance of at least 5 meters."
        },
        {
          "step": "Step 3",
          "title": "Avoid Eye Contact",
          "desc":
              "Do not look directly at the animal and do not make sudden movements."
        },
        {
          "step": "Step 4",
          "title": "Slowly Move Back",
          "desc": "Move away slowly without turning your back on the animal."
        },
      ],
    );
  }
}

class HighRiskPage extends StatelessWidget {
  const HighRiskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RiskDetailPage(
      title: "High Risk",
      subtitle: "Facing Dangerous Wildlife",
      image: "assets/images/tiger.png",

      steps: [
        {
          "step": "Step 1",
          "title": "Stay Calm",
          "desc": "Observe from a safe distance."
        },
        {
          "step": "Step 2",
          "title": "Keep Your Distance",
          "desc": "Be aware of the animal's movement."
        },
        {
          "step": "Step 3",
          "title": "Find Safe Shelter",
          "desc":
              "Move to a secure place (building or vehicle)."
        },
        {
          "step": "Step 4",
          "title": "Call Authorities",
          "desc": "Contact wildlife rescue or emergency services immediately"
        },
      ],
    );
  }
}

class ExtremeRiskPage extends StatelessWidget {
  const ExtremeRiskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RiskDetailPage(
      title: "Extreme Risk",
      subtitle: "Critical Wildlife Situation",
      image: "assets/images/snake.png",

      steps: [
        {
          "step": "Step 1",
          "title": "Stay Calm",
          "desc": "Observe from a safe distance."
        },
        {
          "step": "Step 2",
          "title": "Evacuate Immediately",
          "desc": "Leave the area as quickly as possible."
        },
        {
          "step": "Step 3",
          "title": "Enter Secure Location",
          "desc":
              "Get inside a closed and safe space."
        },
        {
          "step": "Step 4",
          "title": "Trigger Emergency Call",
          "desc": "Contact wildlife rescue or emergency services immediately"
        },
      ],
    );
  }
}

class RiskDetailPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final List<Map<String, String>> steps;

  const RiskDetailPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.steps,
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Safety Guide",
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: darkGreen,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 22),

              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    image,
                    width: image.contains('cow') ? 150 : 149,
                    height: image.contains('cow') ? 124 : 121,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              ...steps.map(
                (step) => _buildStepCard(
                  step["step"]!,
                  step["title"]!,
                  step["desc"]!,
                ),
              ),

              const SizedBox(height: 24),

              Center(
                child: SizedBox(
                  width: 220,
                  height: 50,

                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EmergencyContactPage(
                            fromPage: 'safety',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    child: const Text(
                      "Emergency Contact",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard(
    String step,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            step,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF154E39),
            ),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
              ),

              borderRadius: BorderRadius.circular(10),
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),

                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 4),

                        Text(
                          description,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: Colors.black54,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                const Icon(
                  Icons.volume_up_outlined,
                  color: Color(0xFF154E39),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}