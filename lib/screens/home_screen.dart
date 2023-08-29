import 'package:estateease/screens/home/home_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  // late MenuProvider menuController;

  // @override
  // void initState() {
  //   super.initState();
  //   menuController = MenuProvider(
  //     vsync: this,
  //   )..addListener(
  //       () => setState(() => {}),
  //     );
  // }

  // @override
  // void dispose() {
  //   menuController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider(
    //   create: (context) => menuController,
    //   child: ZoomHomePage(
    //     menuScreen: const MenuPage(),
    //     contentScreen: Layout(
    //       contentBuilder: (cc) => const HomePage(),
    //     ),
    //   ),
    // );
    return HomePage();
  }
}
