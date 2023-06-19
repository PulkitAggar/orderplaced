import 'package:flutter/material.dart';
import 'package:mycycleclinic/screens/roadside_ass_screen.dart';
import '../fragments/BMHomeFragment2.dart';
import 'cart_screen_2.dart';
import 'screens.dart';
import 'package:nb_utils/nb_utils.dart';
import '../fragments/fragments.dart';
import '../utils/BMColors.dart';

class DashboardScreen extends StatefulWidget {
  String city;

  DashboardScreen(this.city);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<DashboardModel> list = getDashboardList();

  int selectedTab = 0;

  void updateSelectedTab(int newSelectedTab) {
    // Update the selected tab value
    selectedTab = newSelectedTab;
    setState(() {});
  }

  Widget getFragment() {
    if (selectedTab == 0) {
      return BMHomeFragment2(
        city: widget.city,
        onTabChanged: updateSelectedTab,
      );
    } else if (selectedTab == 1) {
      return RoadSideAssistance();
    } else if (selectedTab == 2) {
      return BMShoppingScreen();
    } else {
      return const ProfileScreen();
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
  list.add(DashboardModel(
      selectedIcon: Icons.shopping_cart,
      unSelectedIcon: Icons.shopping_cart_outlined));
  list.add(DashboardModel(
      selectedIcon: Icons.person, unSelectedIcon: Icons.person_outline));

  return list;
}
