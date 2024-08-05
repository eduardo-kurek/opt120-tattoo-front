import 'package:flutter/material.dart';

class UserMenu extends StatelessWidget {
  const UserMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Conta'),
            onTap: () {
              // TODO: ao clicar abrir modal/menu para editar a conta
            },
          ),
          // Add more ListTile widgets for additional menu items
        ],
      ),
    );
  }
}
