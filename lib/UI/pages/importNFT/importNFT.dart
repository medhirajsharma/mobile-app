import 'package:crypto_wallet/UI/common_widgets/bottomRectangularbtn.dart';
import 'package:crypto_wallet/UI/common_widgets/inputFields.dart';
import 'package:crypto_wallet/constants/colors.dart';
import 'package:crypto_wallet/controllers/appController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/commonWidgets.dart';

class ImportNFT extends StatefulWidget {
  const ImportNFT({super.key});

  @override
  State<ImportNFT> createState() => _ImportNFTState();
}

class _ImportNFTState extends State<ImportNFT> {
  final appController = Get.find<AppController>();
  var selectedNetwork = ''.obs;
  List allNetworks = <String>[
    'BSC',
    'Solana',
    'Polygon',
    'Ethereum'
  ];
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: primaryColor.value,
      body: ListView(
        padding: EdgeInsets.zero,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 110,
            padding: EdgeInsets.only(top: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CommonWidgets().appBar(hasBack: true, title: 'Import NFT'),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            decoration: BoxDecoration(
              color: primaryBackgroundColor.value,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            constraints: BoxConstraints(minHeight: Get.height - 110, minWidth: Get.width),
            child: Container(
              height: Get.height - 231,
              child: Column(
                // shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                // padding: EdgeInsets.only(bottom: 35, top: 0),
                children: [
                  SizedBox(height: 40,),
                  Text(
                    "Network Selection",
                    style: TextStyle(
                        fontFamily: "SF Pro Rounded",
                        fontSize: 14.0,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.44,
                        color: headingColor.value
                    ),
                  ),
                  SizedBox(height: 16,),
                  GestureDetector(
                    onTap: (){
                      _selectNetworkBottomSheet(context);
                    },
                    child: Container(
                      width: Get.width,
                      height: 60,
                      decoration: BoxDecoration(
                        color: inputFieldBackgroundColor.value,
                        borderRadius: BorderRadius.circular(12)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 22,horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedNetwork.value != '' ? selectedNetwork.value : "Network",
                            style: TextStyle(
                              fontFamily: "sfpro",
                              fontSize: 14.0,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.44,
                              color: appController.isDark.value ? labelColor.value : placeholderColor
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,color: appController.isDark.value ? labelColor.value : placeholderColor,size: 16,),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InputFields(headerText: 'NFT Contract Address', hintText: '0x000...000', hasHeader: true, onChange: (v){}),
                  SizedBox(
                    height: 16,
                  ),
                  InputFields(headerText: 'Token ID', hintText: '123', hasHeader: true, onChange: (v){}),
                  SizedBox(height: Get.height * 0.4),
                  BottomRectangularBtn(onTapFunc: (){

                  }, btnTitle: 'Import')

                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
  Future _selectNetworkBottomSheet(BuildContext context,) {
    return Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: primaryBackgroundColor.value,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      Container(
        padding: EdgeInsets.all(20),
        height: Get.height * 0.7,
        decoration: BoxDecoration(color: primaryBackgroundColor.value, borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Network",
                  style: TextStyle(fontFamily: 'sfpro', fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 26.0, letterSpacing: 0.44, color: headingColor.value),
                ),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.clear,
                      color: headingColor.value,
                    ))
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Expanded(
              child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: allNetworks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        Get.back();
                        selectedNetwork.value = allNetworks[index];
                      },
                      child: Container(
                        width: Get.width,
                        height: 60,
                        decoration: BoxDecoration(
                          color: cardColor.value,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              allNetworks[index],
                              textAlign: TextAlign.left,
                              style: TextStyle(fontFamily: 'sfpro', fontSize: 14.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, color: headingColor.value),
                            ),
                          ],
                        ),
                      ),
                    );
                  }, separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 16,); },),
            ),
          ],
        ),
      ),
    );
  }
}
