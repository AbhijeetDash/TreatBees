import 'package:TreatBees/utils/colors.dart';
import 'package:TreatBees/utils/widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // get carousels.. and create the cards array
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List cards = [
      CarousTile(
        size: size,
        url:
            'https://images.unsplash.com/photo-1496412705862-e0088f16f791?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
        title: "Pre Order Now!",
        subTitle: "Order now and eat later",
      ),
      CarousTile(
        size: size,
        url:
            'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
        title: "Hello",
        subTitle: "Welcome to TreatBees",
      )
    ];

    return Scaffold(
        drawer: Drawer(
          child: Container(
            color: MyColors().alice,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      height: 200,
                      width: size.width * 0.9,
                      alignment: Alignment.center,
                      child: Container(
                        height: 200,
                        width: size.width * 0.9,
                        alignment: Alignment.centerLeft,
                        child: ListTile(
                          title: Text(
                            "Julia Nolk",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          subtitle: Text(
                            "juila.nolk@gmail.com",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1573275048283-c4945bdedbe7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60'),
                          ),
                        ),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                              Colors.grey[850].withOpacity(0.6),
                              Colors.black.withOpacity(0.8)
                            ])),
                      ),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'https://images.unsplash.com/photo-1484300681262-5cca666b0954?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60'))),
                    ),
                    SizedBox(height: 20),
                    OptionTile(
                      icon: Icons.history,
                      title: "Orders",
                      subTitle: "View recent orders",
                    ),
                    OptionTile(
                      icon: Icons.confirmation_num_rounded,
                      title: "Collect Order",
                      subTitle: "Collect your Active Order",
                    ),
                    OptionTile(
                      icon: Icons.group,
                      title: "Gangs",
                      subTitle: "Order with your Gang",
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("version 1.0 MVP"),
                )
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: MyColors().alice,
          elevation: 0.0,
          titleSpacing: 0.0,
          title: Hero(
            tag: "Title",
            child: TitleWidget(),
          ),
          actions: [UserAppBarTile()],
        ),
        body: Container(
          alignment: Alignment.center,
          color: MyColors().alice,
          child: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                flex: 2,
                child: CarouselSlider(
                  height: 250.0,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  pauseAutoPlayOnTouch: Duration(seconds: 5),
                  aspectRatio: 2.0,
                  items: cards.map((card) {
                    return Builder(builder: (BuildContext context) {
                      return Container(
                          height: MediaQuery.of(context).size.height * 0.30,
                          width: MediaQuery.of(context).size.width,
                          child: card);
                    });
                  }).toList(),
                ),
              ),
              Expanded(
                flex: 4,
                // this list view would be dynamic
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                      child: Text(
                        "Cafeterias",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Cafetile(
                      icon: Icons.local_cafe_outlined,
                      title: "Cafe Coffee Day",
                      subtitle: "Visit for offers",
                    ),
                    Cafetile(
                      icon: Icons.fastfood,
                      title: "KFC",
                      subtitle: "Visit for offers",
                    ),
                    Cafetile(
                      icon: Icons.food_bank_outlined,
                      title: "Canteen",
                      subtitle: "Visit for offers",
                    ),
                    Cafetile(
                      icon: Icons.local_cafe_outlined,
                      title: "Cafe Coffee Day",
                      subtitle: "Visit for offers",
                    ),
                    Cafetile(
                      icon: Icons.fastfood,
                      title: "KFC",
                      subtitle: "Visit for offers",
                    ),
                    Cafetile(
                      icon: Icons.food_bank_outlined,
                      title: "Canteen",
                      subtitle: "Visit for offers",
                    ),
                    Cafetile(
                      icon: Icons.local_cafe_outlined,
                      title: "Cafe Coffee Day",
                      subtitle: "Visit for offers",
                    ),
                    Cafetile(
                      icon: Icons.fastfood,
                      title: "KFC",
                      subtitle: "Visit for offers",
                    ),
                    Cafetile(
                      icon: Icons.food_bank_outlined,
                      title: "Canteen",
                      subtitle: "Visit for offers",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: CustomFloatingActionButton());
  }
}
