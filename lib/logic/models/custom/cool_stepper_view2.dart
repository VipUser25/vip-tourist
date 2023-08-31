import 'package:flutter/material.dart';
import 'package:vip_tourist/logic/models/custom/cool_step2.dart';
import 'package:vip_tourist/logic/models/custom/cool_stepper_config2.dart';

class CoolStepperView2 extends StatelessWidget {
  final CoolStep2 step;
  final VoidCallback? onStepNext;
  final VoidCallback? onStepBack;
  final EdgeInsetsGeometry? contentPadding;
  final CoolStepperConfig2? config;

  const CoolStepperView2({
    Key? key,
    required this.step,
    this.onStepNext,
    this.onStepBack,
    this.contentPadding,
    required this.config,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final title = config!.isHeaderEnabled && step.isHeaderEnabled
        ? Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 20.0),
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: config!.headerColor ??
                  Theme.of(context).primaryColor.withOpacity(0.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          step.title.toUpperCase(),
                          style: config!.titleTextStyle ??
                              TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black38,
                              ),
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Visibility(
                        visible: config!.icon == null,
                        replacement: config!.icon ?? SizedBox(),
                        child: Icon(
                          Icons.help_outline,
                          size: 18,
                          color: config!.iconColor ?? Colors.black38,
                        ),
                      )
                    ]),
                SizedBox(height: 5.0),
                Text(
                  step.subtitle,
                  style: config!.subtitleTextStyle ??
                      TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                ),
              ],
            ),
          )
        : SizedBox();

    final content = Expanded(
      child: SingleChildScrollView(
        padding: contentPadding,
        child: step.content,
      ),
    );

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [title, content],
      ),
    );
  }
}
