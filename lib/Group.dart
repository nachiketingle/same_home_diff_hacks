import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Guest/JoinGroup.dart';
import 'package:samehomediffhacks/Host/SettingsPage.dart';
import 'package:samehomediffhacks/Helpers/AppThemes.dart';

class Group extends StatefulWidget {
  final int index;
  Group({Key key, @required this.index}) : super(key: key);
  _Group createState() => _Group();
}

class _Group extends State<Group> with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(
        child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text('Create Group'))),
    Tab(
        child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text('Join Group'))),
  ];
  TabController _tabController;

  void setTab(int index) {
    _tabController.animateTo(index);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController.animateTo(widget.index);
    print(widget.index);
  }

  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: DefaultTabController(
            length: 2,
            child: Stack(
              children: <Widget>[
                Opacity(
                  opacity: .8,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [Colors.cyan[200], Colors.purple[200]]),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Container(
                        child: TabBar(
                      controller: _tabController,
                      tabs: myTabs,
                      labelColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.label,
                      unselectedLabelColor: Colors.white,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.deepPurpleAccent[100]),
                    )),
                    Expanded(
                        child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[SettingsPage(), JoinGroup()],
                    )),
                  ],
                ),
              ],
            )));
  }
}
