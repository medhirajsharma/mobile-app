import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_wallet/models/allNftsModel.dart';
import 'package:crypto_wallet/services/apiService.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:crypto_wallet/constants/colors.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controllers/appController.dart';
import '../../../services/utilServices.dart';
import '../../common_widgets/bottomRectangularbtn.dart';
import '../../common_widgets/commonWidgets.dart';
import 'package:http/http.dart' as http;

class NftDetail extends StatefulWidget {
  const NftDetail({super.key, required this.url, required this.nft});

  final String url;
  final AllNftsModel nft;

  @override
  State<NftDetail> createState() => _NftDetailState();
}

class _NftDetailState extends State<NftDetail> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetail();
  }

  getDetail() {
    ApiService().getNFTDetail(tokenUri: widget.nft.tokenUri);
  }

  final appController = Get.find<AppController>();

  TextEditingController addressController = new TextEditingController();
  var addressErr = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: primaryColor.value,
          body: Column(
            //padding: EdgeInsets.zero,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 110,
                padding: EdgeInsets.only(top: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CommonWidgets().appBar(hasBack: true, title: 'NFT'),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.nft.name}",
                          style: TextStyle(fontFamily: 'sfpro', fontSize: 18.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, color: headingColor.value),
                        ),
                        Text(
                          "#${widget.nft.tokenId}",
                          style: TextStyle(fontFamily: 'sfpro', fontSize: 14.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, color: headingColor.value),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: Get.height - 180,
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 35, top: 0),
                        children: [
                          Hero(
                            tag: widget.nft.id!,
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: cardColor.value),
                              clipBehavior: Clip.antiAlias,
                              width: Get.width,
                              height: Get.width - 32,
                              child: CachedNetworkImage(
                                imageUrl: widget.url,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Description",
                            style: TextStyle(fontFamily: "sfpro", fontSize: 18.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, color: headingColor.value),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          appController.getNFTDetailLoader.value == true
                              ? Column(
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.withOpacity(0.25),
                                      highlightColor: Colors.grey.withOpacity(0.5),
                                      child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        width: Get.width,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.withOpacity(0.25),
                                      highlightColor: Colors.grey.withOpacity(0.5),
                                      child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        width: Get.width,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.withOpacity(0.25),
                                      highlightColor: Colors.grey.withOpacity(0.5),
                                      child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        width: Get.width,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                  ],
                                )
                              : Text(
                                  "${appController.nftDetail.value.description}",
                                  style: TextStyle(
                                      fontFamily: "sfpro", fontSize: 14.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, letterSpacing: 0.44, color: placeholderColor),
                                  textAlign: TextAlign.justify,
                                ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Properties",
                            style: TextStyle(fontFamily: "sfpro", fontSize: 18.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, color: headingColor.value),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Network",
                                  style: TextStyle(fontFamily: "sfpro", fontSize: 14.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, color: placeholderColor),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${widget.nft.network?.name ?? ''}",
                                  style: TextStyle(fontFamily: "sfpro", fontSize: 14.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, color: headingColor.value),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Contract Address",
                                  style: TextStyle(fontFamily: "sfpro", fontSize: 14.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, color: placeholderColor),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        UtilService().copyToClipboard(widget.nft.contractAddress??'');
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: ImageIcon(
                                          AssetImage("assets/imgs/Icons1.png"),
                                          color: primaryColor.value,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4,),
                                    Text(
                                      "${widget.nft.contractAddress!.substring(0, 5) + '...' + widget.nft.contractAddress!.substring(widget.nft.contractAddress!.length - 4)}",
                                      style: TextStyle(fontFamily: "sfpro", fontSize: 14.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, color: headingColor.value),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          BottomRectangularBtn(
                            btnTitle: 'Transfer',
                            onTapFunc: (){
                              _sendNFTSheeet(context,);
                            },
                          ),

                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
  Future _sendNFTSheeet(BuildContext context,) {
    addressController.clear();
    return Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      Obx(
        ()=> Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: primaryBackgroundColor.value, borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Transfer ${widget.nft.name}",
                      style: TextStyle(fontFamily: 'sfpro', fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 26.0, letterSpacing: 0.44, color: headingColor.value),
                    ),
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
                height: 40,
              ),
              Text(
                'Recipient address',
                style: TextStyle(
                  color: placeholderColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'sfpro',
                ),
              ),
              SizedBox(height: 8,),
              TextField(
                cursorColor: primaryColor.value,
                cursorHeight: 20,
                controller: addressController,
                style: TextStyle(fontSize: 14, fontFamily: 'sfpro', color: inputFieldTextColor.value),
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: 14, fontFamily: 'sfpro', color: appController.isDark.value ? labelColor.value : placeholderColor),
                  filled: true,
                  fillColor: inputFieldBackgroundColor.value,
                  hintText: '0x000...000',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                    borderSide: BorderSide(color: cardColor.value, width: 0.1),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                    borderSide: BorderSide(color: cardColor.value, width: 0.1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                    borderSide: BorderSide(color: cardColor.value, width: 0.1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: cardColor.value, width: 0.1),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                  ),
                ),
                onChanged: (value) {
                  addressErr.value = '';
                },
              ),
              CommonWidgets.showErrorMessage(addressErr.value),
              SizedBox(
                height: 16,
              ),
              BottomRectangularBtn(
                btnTitle: 'Transfer',
                isLoading: appController.sendNftLoader.value,
                loadingText: 'Processing...',
                onTapFunc: (){
                  if(addressController.text.trim() == '') {
                    addressErr.value = 'Please enter the address';
                  } else {
                    ApiService().sendNft(
                      networkId: widget.nft.networkId,
                        toAddress: addressController.text,
                        nftAddress: widget.nft.contractAddress,
                        type: widget.nft.type,
                      tokenID: widget.nft.tokenId
                    ).then((value) {
                      if(value == 'OK'){
                        Get.back();
                        Get.back(result: 'sent');
                      }
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
