import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../routes/app_routes.dart';

class RegionsPage extends StatefulWidget {
  final QRouter router;
  const RegionsPage(this.router, {super.key});

  @override
  State<RegionsPage> createState() => _RegionsPageState();
}

class _RegionsPageState extends State<RegionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AppRoutes.regions.length,
      vsync: this,
    );

    // Add listener to update the selected tab when the route changes
    // from outside of this widget.
    widget.router.navigator.addListener(_updateTab);
    // Update the selected tab at start, in case the route was not the default route.
    _updateTab();
  }

  void _updateTab() {
    _tabController.animateTo(
      AppRoutes.regions.indexOf(widget.router.navigator.currentRoute.name!),
    );
  }

  @override
  void dispose() {
    widget.router.navigator.removeListener(_updateTab);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          onTap: (value) {
            QR.toName(AppRoutes.regions[value]);
          },
          tabs: AppRoutes.regions.map((e) => Tab(text: e)).toList(),
        ),
      ),
      body: widget.router,
    );
  }
}
