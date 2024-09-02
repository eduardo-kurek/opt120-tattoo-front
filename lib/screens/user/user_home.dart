import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatuagem_front/DAO/ScheduleDAO.dart';
import 'package:tatuagem_front/DAO/TattooDAO.dart';
import 'package:tatuagem_front/Models/Schedule.dart';
import 'package:tatuagem_front/Models/Tattoo.dart';
import 'package:tatuagem_front/screens/components/authenticate.dart';
import 'package:tatuagem_front/screens/components/menu.dart';
import 'package:tatuagem_front/screens/components/user_menu.dart';
import 'package:tatuagem_front/utils/TokenProvider.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  List<Schedule> _schedules = [];

  void _refreshData() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    ScheduleDAO dao = ScheduleDAO(tokenProvider: tokenProvider);
    var decoded = tokenProvider.decodedToken;
    final String id = decoded['id'];

    _schedules = await dao.getAllByUserId(id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Authenticate(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
        ),
        drawer: const Menu(),
        body: Container(
          color: Colors.black87,
          padding: const EdgeInsets.all(50),
          child: ListView.builder(
            itemCount: _schedules.length,
            itemBuilder: (context, i) => Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(_schedules[i].id),
                      subtitle: Text(_schedules[i].horario),
                    ),
                    const Divider(height: 10),
                    Text(_schedules[i].horario)
                  ],
                )
              )
            ),
          ),
          ),
        ),
    );
  }
}
