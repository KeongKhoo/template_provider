import 'package:flutter/material.dart';
import 'package:template_provider/helper/network_info.dart';
import 'package:template_provider/helper/responsive_helper.dart';
import 'package:template_provider/localization/language_constrants.dart';
import 'package:template_provider/util/color_resources.dart';
import 'package:template_provider/util/styles.dart';
import 'package:template_provider/view/screen/home/home_screen.dart';

class DashboadrdScreen extends StatefulWidget {
  final int pageIndex;
  const DashboadrdScreen({Key key, this.pageIndex}) : super(key: key);

  @override
  State<DashboadrdScreen> createState() => _DashboadrdScreenState();
}

class _DashboadrdScreenState extends State<DashboadrdScreen> {
  PageController _pageController;
  int _pageIndex = 0;
  List<Widget> _screen;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screen = [HomeScreen(), HomeScreen(), HomeScreen()];

    if (ResponsiveHelper.isMobilePhone()) {
      NetworkInfo.checkConnectivity(_scaffoldKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: ResponsiveHelper.isMobile(context)
            ? BottomNavigationBar(
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: ColorResources.COLOR_GREY,
                showUnselectedLabels: true,
                currentIndex: _pageIndex,
                type: BottomNavigationBarType.fixed,
                items: [
                  _barItem(Icons.home, getTranslated('home', context), 0),
                  _barItem(Icons.home, getTranslated('home', context), 1),
                  _barItem(Icons.home, getTranslated('home', context), 2)
                ],
                onTap: (int index) {
                  _setPage(index);
                },
              )
            : SizedBox(),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screen.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screen[index];
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _barItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon,
              color: index == _pageIndex
                  ? Theme.of(context).primaryColor
                  : ColorResources.COLOR_GREY,
              size: 25),
          index == 1
              ? Positioned(
                  top: -7,
                  right: -7,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child: Text(
                      '10',
                      style: rubikMedium.copyWith(
                          color: ColorResources.COLOR_WHITE, fontSize: 8),
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
      label: label,
    );
  }

  void _setPage(int index) {
    setState(() {
      _pageController.jumpToPage(index);
      _pageIndex = index;
    });
  }
}
