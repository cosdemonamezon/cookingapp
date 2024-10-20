import 'package:cookingapp/constants.dart';
import 'package:cookingapp/home/Search/searchPage.dart';
import 'package:cookingapp/home/detailFood/DetailFoodNew.dart';
import 'package:cookingapp/home/firstPage.dart';
import 'package:cookingapp/home/services/homeApi.dart';
import 'package:cookingapp/home/widgets/CardRestaurantWidget.dart';
import 'package:cookingapp/model/food.dart';
import 'package:cookingapp/models/restaurant.dart';
import 'package:cookingapp/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';

class PresenFoodPage extends StatefulWidget {
  const PresenFoodPage({super.key});

  @override
  State<PresenFoodPage> createState() => _PresenFoodPageState();
}

class _PresenFoodPageState extends State<PresenFoodPage> {
  final ScrollController scrollController = ScrollController();
  double appBarOpacity = 0.0;
  int selectTab = 0;
  List<Restaurant> restaurants = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getlistRestaurants();
    });

    // เพิ่ม Listener เพื่อตรวจจับการเลื่อน
    scrollController.addListener(() {
      double offset = scrollController.offset;
      double newOpacity = (offset / 150).clamp(0.0, 1.0);

      if (newOpacity != appBarOpacity) {
        setState(() {
          appBarOpacity = newOpacity;
        });
      }
    });
  }

  //ดึงข้อมูล api Restaurants
  Future<void> getlistRestaurants() async {
    try {
      LoadingDialog.open(context);
      final _restaurants = await HomeApi.getRestaurants();
      if (!mounted) return;

      setState(() {
        restaurants = _restaurants;
      });
      //inspect(categories);
      LoadingDialog.close(context);
    } on Exception catch (e) {
      if (!mounted) return;
      LoadingDialog.close(context);
      print(e);
    }
  }

  List<String> manuFoods = [
    'ผัดกระเพรา',
    'ผัดพริกแกง',
    'ต้มยำ',
    'ผัดพริกเกลือ',
    'อาหารจานเดียว',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.072),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            // backgroundColor: red1.withOpacity(appBarOpacity),
            backgroundColor: Color.fromARGB(81, 207, 124, 9),
            elevation: appBarOpacity > 0.5 ? 4.0 : 0.0,
            title: Padding(
              padding: EdgeInsets.only(top: size.height * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return SearchPage();
                      }));
                    },
                    child: Container(
                      height: size.height * 0.045,
                      width: size.width * 0.85,
                      padding: EdgeInsets.all(size.height * 0.005),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: size.width * 0.001),
                        borderRadius: BorderRadius.circular(15),
                        color: Color.lerp(Colors.transparent, Colors.white, appBarOpacity),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: size.width * 0.33,
                              // child: TextFormField(
                              //   decoration: InputDecoration(
                              //     border: InputBorder.none,
                              //     hintText: 'ค้นหาสินค้า',
                              //     hintStyle: TextStyle(),
                              //     contentPadding: EdgeInsets.only(left: size.width * 0.02, bottom: size.height * 0.01),
                              //   ),
                              // ),
                              child: Text(
                                'ค้นหาสินค้า',
                                style: TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                            ),
                            // Image.asset(
                            //   'assets/icons/cam.png',
                            //   color: red1,
                            // ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: size.height * 0.05,
                                width: size.width * 0.264,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: red1,
                                ),
                                child: Center(
                                  child: Text(
                                    'ค้นหา',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FirstPage()));
                      },
                      child: Icon(Icons.home))
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: size.height * 0.4,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/backgroundLogin.png'), fit: BoxFit.fitWidth),
                // color:Color.fromARGB(81, 207, 124, 9),,
                borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(100, 100))),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        manuFoods.length,
                        (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectTab = index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 3,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            height: size.height * 0.04,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectTab == index ? brown : Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                manuFoods[index],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: selectTab == index ? brown : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                foods.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                        child: SingleChildScrollView(
                          child: Wrap(
                            children: List.generate(
                              foods.length,
                              (index) => CardRestaurantWidget(
                                  size: size,
                                  name: foods[index].name,
                                  address: 'ร้านอาหารใกล้ฉัน',
                                  image: foods[index].image,
                                  km: foods[index].reviews.toString(),
                                  rate: foods[index].rate.toString(),
                                  press: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailFoodNewPage(
                                                  food: foods[index],
                                                )));
                                  }),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
