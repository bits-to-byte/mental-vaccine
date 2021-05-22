import 'package:camera/camera.dart';
import 'package:covid_help/components/boundary_box.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  List<CameraDescription> cameras;
  CameraController cameraController;
  bool isDetecting = false;
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;

  @override
  void initState() {
    super.initState();
    //
    setState(() {
      __mlStart();
    });
  }

  __mlStart() {
    loadModel();
    _initializeCamera();
  }

  void loadModel() async {
    await Tflite.loadModel(
      model: "assets/ml_trained_model/model_unquant.tflite",
      labels: "assets/ml_trained_model/labels.txt",
    );
  }

  void _initializeCamera() async {
    //loadModel();
    cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.high);
    cameraController.initialize().then(
      (_) {
        if (!mounted) {
          return;
        }
        cameraController.startImageStream(
          (CameraImage img) {
            if (!isDetecting) {
              isDetecting = true;
              Tflite.runModelOnFrame(
                bytesList: img.planes.map(
                  (plane) {
                    return plane.bytes;
                  },
                ).toList(),
                imageHeight: img.height,
                imageWidth: img.width,
                numResults: 2,
              ).then(
                (recognitions) {
                  setRecognitions(recognitions, img.height, img.width);
                  isDetecting = false;
                },
              );
            }
          },
        );
      },
    );
  }

  void setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Container(
      constraints: const BoxConstraints.expand(),
      child: cameraController == null
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: cameraController.value.aspectRatio,
                    child: CameraPreview(cameraController),
                  ),
                ),
                BoundaryBox(
                    _recognitions == null ? [] : _recognitions,
                    math.max(_imageHeight, _imageWidth),
                    math.min(_imageHeight, _imageWidth),
                    screen.height,
                    screen.width),
              ],
            ),
    );
  }
}
