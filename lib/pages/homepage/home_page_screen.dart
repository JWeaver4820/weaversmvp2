import 'package:flutter/material.dart';
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

class HomePageScreen extends StatefulWidget{
  HomeScreenViewModel? homeScreenViewModel;

   HomePageScreen( {Key? key, this.homeScreenViewModel}) : super(key: key);

  @override
 HomePageScreenState createState() {
    return  HomePageScreenState();
  }

}

class HomePageScreenState extends State<HomePageScreen>{

    Widget get _defaultMargin  => const SizedBox(height: 30,);

    final PageController _pageController = PageController(initialPage: 2);

    final homeScreenViewModel = HomeScreenViewModel(DatabaseService(), PrefsManager());


    MetabolismScreen newScreen =  MetabolismScreen();

    int curPage = 0;

    @override
  void initState() {
    homeScreenViewModel.runTask();
    if(mounted){
      homeScreenViewModel.logOut.listen((event) {
      context.startNewTaskPage(child: Welcome());

    }, onError: (error){
    ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(content: Text(error.toString())));
    });


  homeScreenViewModel.launchWeight.listen((event) {
    if(mounted){
      Navigator.push(context, MaterialPageRoute(builder: (settings){
        return WeightScreen();
      }));
    }

  }, onError: (error){
      print("There is an error => $error");
  });
    }
    
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
 
   homeScreenViewModel.getUserData();


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
      children:  [
        _buildProfileSnippet(),
        _defaultMargin,
        _buildTopButton(),
        _defaultMargin,
        _buildBody()
      ],
    ),)),
    );
  }


    void _showSettingsPanel() {

      showModalBottomSheet(

        context: context, builder: (context) {

        return Container(

          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),

        );

      }

      );

    }

  Widget _buildTopButton(){

    List<PageItem> menus = [PageItem(page: 0, title: "Meal Plan"),
     PageItem(page: 1, title: "Metabolic"),
      PageItem(page: 2, title:  "Profile")];
    return Row(
      children:menus.map((e) => Expanded(child: InkWell(
        onTap: (){
          if(curPage == e.page){
            if(curPage == 1){
              newScreen.back();
            }
            return;
          }
          // Change page
          _pageController.jumpToPage(e.page);
       
        },
        child: Container
      (alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3)
      ),
       child: Text(e.title),
       ),
      ))).toList(),
    );
  }

  Widget _buildProfileSnippet(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      const Expanded(child: ClipRRect(child: Icon(Icons.ac_unit,
       color: Colors.amber, size: 100,), ), flex: 0,),
      Expanded(
      flex: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text("Text Text"),
             Text("Text Text2"),
                Text("Text Text3"),
                   Text("Text Text4"),
          
        ],
      ),)
      
    ],);
  }

  Widget _buildBody(){

    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: PageView(
        onPageChanged: (index){
          print("print => $curPage == $index");
          curPage = index;
        },
      controller: _pageController,
        children: [
          const MealPlanScreen(),
          newScreen,
          ProfileScreen(homeScreenViewModel:
          homeScreenViewModel
          )
        ],
    ));
  }


  @override
  void dispose() {
   homeScreenViewModel.dispose();
    super.dispose();
  }

}