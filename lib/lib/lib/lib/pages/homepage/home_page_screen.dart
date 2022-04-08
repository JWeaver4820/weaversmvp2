import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:weaversmvp/models/user.dart' as model;
import 'package:weaversmvp/operations/database.dart';
import 'package:weaversmvp/pages/subpages/MealPlan/mealplan.dart';
import 'package:weaversmvp/pages/subpages/Metabolism/metabolism.dart';
import 'package:weaversmvp/pages/subpages/Profile/profile_screen.dart';
import 'package:weaversmvp/pages/homepage/page_item.dart';
import 'package:weaversmvp/pages/welcome/welcome.dart';
import 'package:weaversmvp/utils/prefs_manager.dart';
import 'package:weaversmvp/pages/weight_scheduler/weight_screen.dart';
import 'home_screen_viewmodel.dart';
import 'package:weaversmvp/utils/dart_exts.dart';

class HomePageScreen extends StatefulWidget {
  HomeScreenViewModel? homeScreenViewModel;

  HomePageScreen({Key? key, this.homeScreenViewModel}) : super(key: key);

  @override
  HomePageScreenState createState() {
    return HomePageScreenState();
  }
}

class HomePageScreenState extends State<HomePageScreen> {
  Widget get _defaultMargin => const SizedBox(
        height: 30,
      );

  final PageController _pageController = PageController(initialPage: 2);

  final homeScreenViewModel =
      HomeScreenViewModel(DatabaseService(), PrefsManager());

  MetabolismScreen? newScreen;

  int curPage = 0;

  @override
  void initState() {
    homeScreenViewModel.runTask();
    if (mounted) {
      homeScreenViewModel.logOut.listen((event) {
        context.startNewTaskPage(child: Welcome());
      }, onError: (error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });

      homeScreenViewModel.launchWeight.listen((event) {
        if (mounted) {
          final page =
              Navigator.push(context, MaterialPageRoute(builder: (settings) {
            return WeightScreen();
          }));
          page.then((isWeightPopped) {
            if (isWeightPopped) {
              homeScreenViewModel.getWeight(false);
            }
          });
        }
      }, onError: (error) {
        print("There is an error => $error");
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    newScreen = MetabolismScreen(homeScreenViewModel);

    homeScreenViewModel.getUserData();

    int? curWeight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.teal[600],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            style: TextButton.styleFrom(primary: Colors.teal[50]),
            icon: const Icon(Icons.person),
            label: const Text('Sign Out'),
            onPressed: () async {
              homeScreenViewModel.signOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileSnippet(),
            _defaultMargin,
            _buildTopButton(),
            _defaultMargin,
            _buildBody()
          ],
        ),
      )),
    );
  }

  void _showSettingsPanel() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          );
        });
  }

  Widget _buildTopButton() {
    List<PageItem> menus = [
      PageItem(page: 0, title: "Meal Plan"),
      PageItem(page: 1, title: "Metabolic"),
      PageItem(page: 2, title: "Profile")
    ];
    return Row(
      children: menus
          .map((e) => Expanded(
                  child: InkWell(
                onTap: () {
                  if (curPage == e.page) {
                    if (curPage == 1) {
                      newScreen?.back();
                    }
                    return;
                  }
                  // Change page
                  _pageController.jumpToPage(e.page);
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 3)),
                  child: Text(e.title),
                ),
              )))
          .toList(),
    );
  }

  Widget _buildProfileSnippet() {
    homeScreenViewModel.getWeight(false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: ClipRRect(
            child: Icon(
              Icons.ac_unit,
              color: Colors.amber,
              size: 100,
            ),
          ),
          flex: 0,
        ),
        Expanded(
          flex: 2,
          child: StreamBuilder<model.User>(
            builder: (_, snapshot) {
              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              }
              model.User user = snapshot.data ?? snapshot.requireData;
              print("print => ${user.weights}");
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(FirebaseAuth.instance.currentUser?.email ??''), //Pull email from user id variable from backend firebase variable targetBodyWeight
                  _buildCurrentWeight(homeScreenViewModel.weight, "pounds"), //Pull weight from the most recent weight entry on the weight list from firebase
                  Text(
                      "Target Body Weight ${user.targetBodyWeight}"), //Pull Target Body Weight variable from backend firebase variable targetBodyWeight
                  _buildCurrentWeight(homeScreenViewModel.weight,  "pounds", subtractor: user.targetBodyWeight ?? 0) // Pounds Remaining to reach goal "), //Pounds Remaining is simply TargetBodyWeight - Current Weight
                ],
              );
            },
            stream: homeScreenViewModel.profileV2,
          ),
        )
      ],
    );
  }


  Widget _buildCurrentWeight(Stream<int> stream, String text, {int subtractor =0}) {
    return Padding(
      padding: EdgeInsets.only(top: 4),
      child: StreamBuilder<int>(
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return const Text(
              "An error has occurred",
              textAlign: TextAlign.start,
            );
          }
          final weightValue = snapshot.data;
          return Text(
            "${((weightValue ?? 0) - subtractor).abs()} $text",
            textAlign: TextAlign.start,
          );
        },
        stream: stream,
      ),
    );
  }

  Widget _buildBody() {
    return Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: PageView(
          onPageChanged: (index) {
            print("print => $curPage == $index");
            curPage = index;
          },
          controller: _pageController,
          children: [
            const MealPlanScreen(),
            newScreen!,
            ProfileScreen(homeScreenViewModel: homeScreenViewModel)
          ],
        ));
  }

  @override
  void dispose() {
    homeScreenViewModel.dispose();
    super.dispose();
  }
}
