import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ModelViewerComponent extends StatelessWidget {
  final String src;
  final String? alt;
  final bool ar;
  final bool autoRotate;
  final bool disableZoom;
  final bool cameraControls;
  final String? maxCameraOrbit;
  final Color backgroundColor;

  const ModelViewerComponent({
    super.key,
    required this.src,
    this.alt,
    this.ar = false,
    this.autoRotate = false,
    this.disableZoom = false,
    this.cameraControls = true,
    this.maxCameraOrbit,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return ModelViewer(
      key: ValueKey(src),
      backgroundColor: backgroundColor,
      src: src,
      alt: alt,
      ar: ar,
      autoRotate: autoRotate,
      disableZoom: disableZoom,
      cameraControls: cameraControls,
      maxCameraOrbit: maxCameraOrbit,
    );
  }
}
