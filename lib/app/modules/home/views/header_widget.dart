import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final VoidCallback onProfileTap;

  const HeaderWidget({Key? key, required this.onProfileTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Halo',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: onProfileTap,
            child: CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
