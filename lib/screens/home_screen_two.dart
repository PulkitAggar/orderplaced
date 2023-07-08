import 'package:flutter/material.dart';
import 'package:mycycleclinic/fragments/BMHomeFragment2two.dart';
import 'package:mycycleclinic/screens/landingScreen2.dart';
import 'package:mycycleclinic/screens/roadside_ass_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/BMColors.dart';
import '../utils/BMDataGenerator.dart';

class DashboardTwo extends StatefulWidget {
  String city;

  DashboardTwo(this.city);

  @override
  State<DashboardTwo> createState() => _DashboardTwoState();
}

class _DashboardTwoState extends State<DashboardTwo> {
  List<DashboardModel> list = getDashboardList();

  int selectedTab = 0;

  void updateSelectedTab(int newSelectedTab) {
    // Update the selected tab value
    selectedTab = newSelectedTab;
    setState(() {});
  }

  Widget getFragment() {
    if (selectedTab == 0) {
      return BMHomeFragment2Two(
        city: widget.city,
        onTabChanged: updateSelectedTab,
      );
    } else {
      return RoadSideAssistance(
        city: widget.city,
      );
    }
  }

  @override
  void initState() {
    setStatusBarColor(Colors.black);
    super.initState();
  }

  @override
  void dispose() {
    // if (widget.flag) {
    //   setStatusBarColor(appStore.isDarkModeOn ? appStore.scaffoldBackground! : bmLightScaffoldBackgroundColor);
    // } else {
    //   setStatusBarColor(Colors.transparent);
    // }

    super.dispose();
  }

  Color getDashboardColor() {
    return bmLightScaffoldBackgroundColor;

    // if (!appStore.isDarkModeOn) {
    //   if (selectedTab == 1 || selectedTab == 2 || selectedTab == 3) {
    //     return bmSecondBackgroundColorLight;
    //   } else {
    //     return bmLightScaffoldBackgroundColor;
    //   }
    // } else {
    //   if (selectedTab == 1 || selectedTab == 2 || selectedTab == 3) {
    //     return bmSecondBackgroundColorDark;
    //   } else {
    //     return appStore.scaffoldBackground!;
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getDashboardColor(),
      body: getFragment(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            selectedTab = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        unselectedItemColor: bmPrimaryColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: selectedTab,
        items: list.map((e) {
          int index = list.indexOf(e);
          return BottomNavigationBarItem(
            icon: Icon(e.unSelectedIcon, color: bmPrimaryColor),
            activeIcon: index == 0
                ? Icon(e.selectedIcon, color: bmPrimaryColor)
                : Icon(e.selectedIcon, color: bmPrimaryColor),
            label: '',
          );
        }).toList(),
      ).cornerRadiusWithClipRRectOnly(topLeft: 32, topRight: 32),
    );
  }
}

class DashboardModel {
  IconData selectedIcon;
  IconData unSelectedIcon;

  DashboardModel({required this.selectedIcon, required this.unSelectedIcon});
}

List<DashboardModel> getDashboardList() {
  List<DashboardModel> list = [];

  list.add(DashboardModel(
      selectedIcon: Icons.home_filled, unSelectedIcon: Icons.home_outlined));
  list.add(DashboardModel(
      selectedIcon: Icons.health_and_safety,
      unSelectedIcon: Icons.health_and_safety_outlined));
  return list;
}
