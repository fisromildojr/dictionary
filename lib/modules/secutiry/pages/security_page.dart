import 'package:dictionary/routes/route_names.dart';
import 'package:dictionary/storage/app_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SecurityPage extends StatefulWidget {
  final Widget child;
  const SecurityPage({
    super.key,
    required this.child,
  });

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  @override
  void initState() {
    if (AppStorage.instance.user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Get.offAllNamed(RouteLoginPage);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
