

  // Future<void> showAlertDialogK(BuildContext cont, HomeScreenTourProvider data,
  //     SimpleFontelicoProgressDialog dialog) async {
  //   showDialog<void>(
  //     barrierDismissible: false,
  //     context: cont,
  //     builder: (context) => StatefulBuilder(
  //       builder: (ctx, setState) => AlertDialog(
  //         title: Text(
  //           S.of(context).selectCity,
  //           style: TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.w600,
  //               color: Colors.blue[600]),
  //         ),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               TextFormField(
  //                 onChanged: (value) {
  //                   setState(() {
  //                     data.onChanged(value);
  //                   });
  //                 },
  //                 autofocus: false,
  //                 style: TextStyle(fontSize: 16),
  //                 enableInteractiveSelection: true,
  //                 decoration: InputDecoration(
  //                   suffixIcon: Icon(Icons.search),
  //                   contentPadding:
  //                       EdgeInsets.only(top: 5, left: 10, right: 10),
  //                   hintText: S.of(context).enterCityName,
  //                   hintStyle: TextStyle(color: Colors.grey[700]),
  //                   filled: true,
  //                   fillColor: Colors.white,
  //                   enabledBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(15),
  //                     borderSide: BorderSide(color: Colors.white),
  //                   ),
  //                   focusedBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(15),
  //                     borderSide: BorderSide(color: Colors.white),
  //                   ),
  //                   disabledBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(15),
  //                     borderSide: BorderSide(color: Colors.white),
  //                   ),
  //                 ),
  //               ),
  //               Container(
  //                 height: 500,
  //                 width: 300,
  //                 child: ListView.builder(
  //                   itemBuilder: (ctx, i) {
  //                     return Padding(
  //                       padding: const EdgeInsets.only(
  //                           left: 15, right: 15, top: 5, bottom: 5),
  //                       child: Row(
  //                         children: [
  //                           OctoImage(
  //                             image: NetworkImage(data.filteredCities[i].flag),
  //                             height: 30,
  //                             width: 52,
  //                             fit: BoxFit.fill,
  //                             placeholderBuilder:
  //                                 OctoPlaceholder.circularProgressIndicator(),
  //                           ),
  //                           SizedBox(
  //                             width: 20,
  //                           ),
  //                           TextButton(
  //                             child: Text(
  //                               data.filteredCities[i].cityName,
  //                               style: TextStyle(
  //                                   fontSize: 20, color: Colors.black),
  //                             ),
  //                             onPressed: () async {
  //                               setState(() {
  //                                 data.setCity(data.filteredCities[i].cityID);
  //                               });
  //                               setState(() {
  //                                 data.setCityName(
  //                                     data.filteredCities[i].cityName);
  //                               });

  //                               dialog.show(
  //                                   message: "Loading...",
  //                                   type: SimpleFontelicoProgressDialogType
  //                                       .hurricane);

  //                               await data.getCityPhoto();

  //                               dialog.hide();

  //                               Navigator.pop(context);
  //                               Navigator.pushReplacement(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) =>
  //                                         BottomNavigationBart()),
  //                               );
  //                             },
  //                           )
  //                         ],
  //                       ),
  //                     );
  //                   },
  //                   itemCount: data.filteredCities.length,
  //                   shrinkWrap: true,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

