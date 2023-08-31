library cool_stepper;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cool_stepper/cool_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/logic/models/custom/cool_step2.dart';
import 'package:vip_tourist/logic/models/custom/cool_stepper_config2.dart';
import 'package:vip_tourist/logic/models/custom/cool_stepper_view2.dart';
import 'package:vip_tourist/logic/providers/cool_stepper_provider.dart';
import 'package:vip_tourist/logic/providers/tour_addition_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';

import '../../../generated/l10n.dart';

/// CoolStepper
class CoolStepper2 extends StatefulWidget {
  /// The steps of the stepper whose titles, subtitles, content always get shown.
  ///
  /// The length of [steps] must not change.
  final List<CoolStep2> steps;

  /// Actions to take when the final stepper is passed
  final VoidCallback onCompleted;

  /// Padding for the content inside the stepper
  final EdgeInsetsGeometry contentPadding;

  /// CoolStepper config
  final CoolStepperConfig2 config;

  /// This determines if or not a snackbar displays your error message if validation fails
  ///
  /// default is false
  final bool showErrorSnackbar;

  final AddTourLocalSave? addTourLocalSave;

  const CoolStepper2({
    Key? key,
    required this.steps,
    required this.onCompleted,
    this.addTourLocalSave,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 20.0),
    this.config = const CoolStepperConfig2(),
    this.showErrorSnackbar = false,
  }) : super(key: key);

  @override
  _CoolStepper2State createState() => _CoolStepper2State();
}

class _CoolStepper2State extends State<CoolStepper2> {
  late PageController _controller;

  int currentStep = 0;

  @override
  void initState() {
    currentStep = context.read<CoolStepperProvider>().currentStep;
    _controller = PageController(initialPage: currentStep);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Future<void>? switchToPage(int page) {
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
    return null;
  }

  bool _isFirst(int index) {
    return index == 0;
  }

  bool _isLast(int index) {
    return widget.steps.length - 1 == index;
  }

  void onStepNext() {
    final validation = widget.steps[currentStep].validation!();

    /// [validation] is null, no validation rule
    if (validation == null) {
      if (!_isLast(currentStep)) {
        setState(() {
          currentStep++;
        });
        if (currentStep < 4) {
          context.read<CoolStepperProvider>().setCurrentStep(currentStep);
        } else {
          context.read<CoolStepperProvider>().setCurrentStep(3);
        }
        FocusScope.of(context).unfocus();
        switchToPage(currentStep);
      } else {
        widget.onCompleted();
      }
    } else {
      if (widget.showErrorSnackbar) {
        EasyLoading.showInfo(S.of(context).pleaseEnter);
      }
    }
  }

  void onStepBack() {
    if (!_isFirst(currentStep)) {
      setState(() {
        currentStep--;
      });
      if (currentStep < 4) {
        context.read<CoolStepperProvider>().setCurrentStep(currentStep);
      } else {
        context.read<CoolStepperProvider>().setCurrentStep(3);
      }

      switchToPage(currentStep);
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Expanded(
      child: WillPopScope(
        onWillPop: () async {
          print("BACK BUTTON PRESSED!!!!");
          if (_isFirst(currentStep)) {
            if (widget.addTourLocalSave != null) {
              OkCancelResult res = await showOkCancelAlertDialog(
                  context: context,
                  cancelLabel: S.of(context).no,
                  okLabel: S.of(context).save,
                  message: S.of(context).wantSaveDraft);
              if (res == OkCancelResult.ok) {
                await context
                    .read<TourAdditionProvider>()
                    .saveLocaly(data: widget.addTourLocalSave!);
                await context.read<CoolStepperProvider>().saveLocally();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    //behavior: SnackBarBehavior.floating,
                    content: Text(
                      S.of(context).draftSaved,
                    ),

                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                context.read<CoolStepperProvider>().setCurrentStep(0);
              }
            }
            Navigator.pop(context);
          } else {
            onStepBack();
          }
          return Future.value(false);
        },
        child: PageView(
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
          children: widget.steps.map((step) {
            return CoolStepperView2(
              step: step,
              contentPadding: widget.contentPadding,
              config: widget.config,
            );
          }).toList(),
        ),
      ),
    );

    final counter = Container(
      child: Text(
        "${widget.config.stepText ?? 'STEP'} ${currentStep + 1} ${widget.config.ofText ?? 'OF'} ${widget.steps.length}",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );

    String getNextLabel() {
      String nextLabel;
      if (_isLast(currentStep)) {
        nextLabel = widget.config.finalText ?? 'FINISH';
      } else {
        if (widget.config.nextTextList != null) {
          nextLabel = widget.config.nextTextList![currentStep];
        } else {
          nextLabel = widget.config.nextText ?? 'NEXT';
        }
      }
      return nextLabel;
    }

    String getPrevLabel() {
      String backLabel;
      if (_isFirst(currentStep)) {
        backLabel = '';
      } else {
        if (widget.config.backTextList != null) {
          backLabel = widget.config.backTextList![currentStep - 1];
        } else {
          backLabel = widget.config.backText ?? 'PREV';
        }
      }
      return backLabel;
    }

    final buttons = Container(
      child: Column(children: [
        Container(
          height: 2,
          decoration: BoxDecoration(color: LIGHT_GRAY),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
              onPressed: onStepBack,
              child: Text(
                getPrevLabel(),
                style: TextStyle(
                    color: GRAY, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            counter,
            TextButton(
              onPressed: onStepNext,
              child: Text(
                getNextLabel(),
                style: TextStyle(
                    color: PRIMARY, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        )
      ]),
    );

    return Container(
      child: Column(
        children: [content, buttons],
      ),
    );
  }
}
