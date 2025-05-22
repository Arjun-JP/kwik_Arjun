import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SoftUpdatePopup extends StatefulWidget {
  const SoftUpdatePopup({super.key});

  @override
  State<SoftUpdatePopup> createState() => _SoftUpdatePopupState();
}

class _SoftUpdatePopupState extends State<SoftUpdatePopup> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );
  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Provide a maxHeight to the Container.  Adjust this value as needed.
      constraints: const BoxConstraints(maxHeight: 400),
      child: ListView(
        children: <Widget>[
          _infoTile('App name', _packageInfo.appName),
          _infoTile('Package name', _packageInfo.packageName),
          _infoTile('App version', _packageInfo.version),
          _infoTile('Build number', _packageInfo.buildNumber),
          _infoTile('Build signature', _packageInfo.buildSignature),
          _infoTile(
            'Installer store',
            _packageInfo.installerStore ?? 'not available',
          ),
          _infoTile(
            'Install time',
            _packageInfo.installTime?.toIso8601String() ??
                'Install time not available',
          ),
          _infoTile(
            'Update time',
            _packageInfo.updateTime?.toIso8601String() ??
                'Update time not available',
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle.isEmpty ? 'Not set' : subtitle),
    );
  }
}
