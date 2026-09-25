import 'dart:math';
import 'package:flutter/material.dart';

class LineChart extends StatelessWidget {
  final List<double> data;
  final List<double> time;
  final Color lineColor;
  final Color gridColor;

  const LineChart({
    super.key,
    required this.data,
    required this.time,
    required this.lineColor,
    required this.gridColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LineChartPainter(
        data: data,
        time: time,
        line: lineColor,
        grid: gridColor,
      ),
      size: Size.infinite,
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final List<double> time;
  final Color line;
  final Color grid;

  _LineChartPainter({
    required this.data,
    required this.time,
    required this.line,
    required this.grid,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Background
    final bg = Paint()..color = const Color(0xFF12151A);
    canvas.drawRect(Offset.zero & size, bg);

    // Grid lines
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    const rows = 5;
    for (int i = 0; i <= rows; i++) {
      final y = h * i / rows;
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    // Range handling
    if (data.length < 2) return;
    final minV = 0.0;
    final maxV = 150.0;
    final rangeV = maxV - minV;

    final minT = time.isEmpty ? 0.0 : time.first;
    final maxT = time.isEmpty ? 3.0 : time.last;
    final rangeT = (maxT - minT).abs() < 1e-6 ? 1.0 : maxT - minT;

    // Draw the line path
    final path = Path();

    for (int i = 0; i < data.length; i++) {
      final normalizedX = (time[i] - minT) / rangeT;
      final x = normalizedX * w;
      final normalizedY = (data[i] - minV) / rangeV;
      final y = h - (normalizedY * (h - 8)) - 4;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevX = (time[i - 1] - minT) / rangeT * w;
        final prevY =
            h - ((data[i - 1] - minV) / rangeV * (h - 8)) - 4;
        final midX = (prevX + x) / 2;
        path.cubicTo(midX, prevY, midX, y, x, y);
      }
    }

    // Gradient glow under the line
    final glowGrad = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        line.withValues(alpha: 0.25),
        line.withValues(alpha: 0.05),
        Colors.transparent,
      ],
    );
    final glowPaint = Paint()
      ..shader = glowGrad.createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;
    final glowPath = Path.from(path)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(glowPath, glowPaint);

    // Main curve line
    final linePaint = Paint()
      ..color = line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) => true;
}
