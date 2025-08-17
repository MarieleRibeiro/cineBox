import 'package:cinebox/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

mixin LoaderAndMessage<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  var isOpen = false;
  void showLoader() {
    if (!isOpen) {
      isOpen = true;
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return Center(
            child: LoadingAnimationWidget.threeArchedCircle(
              color: Colors.white,
              size: 60,
            ),
          );
        },
      );
    }
  }

  void hideLoader() {
    if (isOpen) {
      isOpen = false;
      Navigator.of(context).pop();
    }
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  void showErrorMessage(String message) =>
      _showMessage(message, AppColors.redColor);

  void showSuccessMessage(String message) =>
      _showMessage(message, Colors.green);

  void showInfoMessage(String message) => _showMessage(message, Colors.blue);
}
