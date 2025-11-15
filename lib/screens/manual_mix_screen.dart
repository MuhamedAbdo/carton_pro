import 'package:flutter/material.dart';

class ManualMixScreen extends StatefulWidget {
  const ManualMixScreen({super.key});

  @override
  State<ManualMixScreen> createState() => _ManualMixScreenState();
}

class _ManualMixScreenState extends State<ManualMixScreen> {
  // القيم الابتدائية: أسود خالص (K=100%)
  double c = 0.0;
  double m = 0.0;
  double y = 0.0;
  double k = 100.0;
  double white = 0.0;

  // تحديث القيم مع الحفاظ على المجموع = 100%
  void _updateValue(String channel, double newValue) {
    // تأمين: newValue يجب أن يكون بين 0 و100
    newValue = newValue.clamp(0.0, 100.0);

    setState(() {
      // حفظ القيم القديمة
      double oldC = c, oldM = m, oldY = y, oldK = k, oldW = white;

      // تحديث القيمة المطلوبة
      if (channel == 'c') c = newValue;
      if (channel == 'm') m = newValue;
      if (channel == 'y') y = newValue;
      if (channel == 'k') k = newValue;
      if (channel == 'white') white = newValue;

      // حساب المجموع الجديد
      double currentSum = c + m + y + k + white;

      // إذا كان المجموع صفرًا (نادر جدًّا)، لا نعيد التوزيع
      if (currentSum <= 0.001) {
        c = m = y = k = white = 0.0;
        if (channel == 'c') {
          c = 100.0;
        } else if (channel == 'm')
          m = 100.0;
        else if (channel == 'y')
          y = 100.0;
        else if (channel == 'k')
          k = 100.0;
        else
          white = 100.0;
        return;
      }

      // إذا كان المجموع = 100، لا حاجة لإعادة التوزيع
      if ((currentSum - 100.0).abs() < 0.01) {
        return;
      }

      // إعادة توزيع باقي القيم (التي لم يتم تغييرها) فقط
      double remaining = 100.0 -
          (channel == 'c'
              ? c
              : channel == 'm'
                  ? m
                  : channel == 'y'
                      ? y
                      : channel == 'k'
                          ? k
                          : white);
      double oldOthersSum = (channel == 'c' ? 0 : oldC) +
          (channel == 'm' ? 0 : oldM) +
          (channel == 'y' ? 0 : oldY) +
          (channel == 'k' ? 0 : oldK) +
          (channel == 'white' ? 0 : oldW);

      if (oldOthersSum > 0 && remaining > 0) {
        double factor = remaining / oldOthersSum;
        if (channel != 'c') c = (oldC * factor).clamp(0.0, 100.0);
        if (channel != 'm') m = (oldM * factor).clamp(0.0, 100.0);
        if (channel != 'y') y = (oldY * factor).clamp(0.0, 100.0);
        if (channel != 'k') k = (oldK * factor).clamp(0.0, 100.0);
        if (channel != 'white') white = (oldW * factor).clamp(0.0, 100.0);
      } else {
        // إذا لم تكن هناك قيم أخرى، نضبط القيمة المختارة على 100%
        c = m = y = k = white = 0.0;
        if (channel == 'c') {
          c = 100.0;
        } else if (channel == 'm')
          m = 100.0;
        else if (channel == 'y')
          y = 100.0;
        else if (channel == 'k')
          k = 100.0;
        else
          white = 100.0;
      }
    });
  }

  // تحويل القيم إلى لون RGB (بدون أبيض في التحويل)
  Color _getCurrentColor() {
    // تأمين ضد القيم غير الصالحة
    double cSafe = c.clamp(0, 100);
    double mSafe = m.clamp(0, 100);
    double ySafe = y.clamp(0, 100);
    double kSafe = k.clamp(0, 100);
    double wSafe = white.clamp(0, 100);

    double rf = 1.0 - (cSafe / 100.0);
    double gf = 1.0 - (mSafe / 100.0);
    double bf = 1.0 - (ySafe / 100.0);
    double kf = 1.0 - (kSafe / 100.0);
    double wp = wSafe / 100.0;
    double lp = 1.0 - wp;

    // تأكد من أن القيم بين 0 و1
    rf = rf.clamp(0.0, 1.0);
    gf = gf.clamp(0.0, 1.0);
    bf = bf.clamp(0.0, 1.0);
    kf = kf.clamp(0.0, 1.0);
    lp = lp.clamp(0.0, 1.0);
    wp = wp.clamp(0.0, 1.0);

    int r = (255 * rf * kf * lp + 255 * wp).round().clamp(0, 255);
    int g = (255 * gf * kf * lp + 255 * wp).round().clamp(0, 255);
    int b = (255 * bf * kf * lp + 255 * wp).round().clamp(0, 255);

    return Color.fromRGBO(r, g, b, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = _getCurrentColor();
    double total = c + m + y + k + white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'خلط يدوي',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Card(
                color: bgColor.computeLuminance() > 0.5
                    ? Colors.black54
                    : Colors.white30,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'الخلطة الحالية',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildChannelRow('C', c.toInt(), Colors.cyan),
                      _buildChannelRow('M', m.toInt(), Colors.pink),
                      _buildChannelRow('Y', y.toInt(), Colors.yellow),
                      _buildChannelRow('K', k.toInt(), Colors.black),
                      _buildChannelRow('W', white.toInt(), Colors.white),
                      const SizedBox(height: 8),
                      Text(
                        'المجموع: ${total.toInt()}%',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildSlider('C', c, Colors.cyan, (v) => _updateValue('c', v)),
              _buildSlider('M', m, Colors.pink, (v) => _updateValue('m', v)),
              _buildSlider('Y', y, Colors.yellow, (v) => _updateValue('y', v)),
              _buildSlider('K', k, Colors.grey, (v) => _updateValue('k', v)),
              _buildSlider(
                  'W', white, Colors.white, (v) => _updateValue('white', v)),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChannelRow(String label, int value, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: label == 'W' ? Colors.grey.shade300 : color,
        ),
        const SizedBox(width: 10),
        Text(
          '$label: $value%',
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildSlider(String label, double value, Color activeColor,
      Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${value.toInt()}%',
          style: TextStyle(
            color: label == 'W' ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Slider(
          value: value,
          min: 0,
          max: 100,
          activeColor: activeColor,
          inactiveColor: activeColor.withOpacity(0.3),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
