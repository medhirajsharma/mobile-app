import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_wallet/UI/pages/importNFT/importNFT.dart';
import 'package:crypto_wallet/UI/pages/nftDetail/nftDetail.dart';
import 'package:crypto_wallet/services/apiService.dart';
import 'package:crypto_wallet/services/utilServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:crypto_wallet/UI/pages/chooseToken/chooseToken.dart';
import 'package:crypto_wallet/UI/pages/history/history.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/colors.dart';
import '../../../controllers/appController.dart';
import '../../../models/coinsModel.dart';
import '../../../models/walletBalanceModel.dart';
import '../../common_widgets/commonWidgets.dart';
import '../biomatric/bioMatricLockScreen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  int currentMax = 1;
  AppController appController = Get.find<AppController>();
  var selectedCoin = CoinsModel().obs;
  var selectedCoinToBalanceModel = Balance().obs;
  var selectCoin = 0.obs;
  var selectedTab = 0.obs;
  List allNfts = <String>[
    'https://img.freepik.com/free-vector/hand-drawn-nft-style-ape-illustration_23-2149622021.jpg',
    'https://media.voguebusiness.com/photos/61b8dfb99ba90ab572dea0bd/2:3/w_2560%2Cc_limit/adidas-nft-voguebus-adidas-nft-dec-21-story.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcF6U85PnULQQQ2aZPjINGuSbuKSJ0dBjCPg&usqp=CAU',
    'https://miro.medium.com/v2/resize:fit:720/1*W8MDnaVPtrfHVYHHgSDyhw.jpeg',
    'https://www.prayananimation.com/img/bg/nftsamurai.png',
    'https://latium.org/storage/prod/wQjdl7eR/full/1000x',
  ];

  getUserData() async {
    appController.getBalanceLoader.value = true;
    ApiService().getLoggedInUser().then((value) {
      if (value == 'OK') {
        ApiService().getAllCoins(limit: 30, offset: 0).then((value) {
          if (value == 'OK') {
            selectedCoin.value = appController.allCoinsList[0];
            selectedCoinToBalanceModel.value.logoUrl = selectedCoin.value.icon;
            selectedCoinToBalanceModel.value.price = selectedCoin.value.price;
            selectedCoinToBalanceModel.value.networkId = selectedCoin.value.networkId!.id;
            selectedCoinToBalanceModel.value.coinId = selectedCoin.value.id;
          }
        });
        ApiService().getWalletWithBalance();
        _refreshController.refreshCompleted();
      }
    });
    appController.shouldCallDashboardApi.value = false;
    //print(appController.user.value?.id);
  }

  getNfts() {
    appController.allNFTsList.clear();
    ApiService().getNfts(limit: 10, offset: 0);
  }
  final _nftGridScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (appController.shouldCallDashboardApi.value == true) {
      getUserData();
    }
    _nftGridScrollController.addListener(() {
      if (_nftGridScrollController.position.atEdge) {
        bool isTop = _nftGridScrollController.position.pixels == 0;
        if (isTop) {
          print('At the top');
        } else {
          print('At the bottom');
          loadMoreNfts();
        }
      }
    });
  }
  loadMoreNfts(){
    ApiService().getNfts(limit: 10,offset: appController.allNFTsList.length,method: 'add');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: appBgGradient,
      ),
      child: Scaffold(
        ///backgroundColor: primaryColor.value,
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          child: Platform.isIOS ? SizedBox(height: 30,) :AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              // Status bar color
              statusBarColor: primaryColor.value,

              // Status bar brightness (optional)
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
            elevation: 0,
          ),
        ),
        body: SafeArea(
          top: Platform.isIOS ? true : false,
          child: Obx(
            () => Container(
              height: Get.height,
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: selectedTab.value == 1 ? true : false,
                header: WaterDropMaterialHeader(
                  backgroundColor: primaryBackgroundColor.value,
                  color: primaryColor.value,
                ),
                controller: _refreshController,
                onRefresh: () {
                  onRefresh();

                },
                onLoading: () {
                  print('======');
                },
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 210,
                          padding: EdgeInsets.only(top: 30, left: 16, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: Get.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Available Balance',
                                      style: TextStyle(
                                        fontFamily: 'sfpro',
                                        color: lightColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0,
                                        letterSpacing: 0.37,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      '${appController.user.value.currency?.symbol ?? ''}${UtilService().toFixed2DecimalPlaces((appController.userBalance.value.wallet?.totalBalanceInLocalCurrency ?? 0).toString())}',
                                      style: TextStyle(
                                        fontFamily: 'sfpro',
                                        color: lightColor,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 40.0,
                                        letterSpacing: 0.36,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 24.0),
                            decoration: BoxDecoration(
                              color: primaryBackgroundColor.value,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            //constraints: BoxConstraints(minHeight: Get.height - 240, minWidth: Get.width),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 60,
                                ),
                                Container(
                                  height: 40,
                                  width: Get.width,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            selectedTab.value = 0;
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border(
                                                bottom: BorderSide(width: 0.5, color: selectedTab.value == 0 ? primaryColor.value : placeholderColor),
                                              ),
                                            ),
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              "Coins",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "sfpro",
                                                  fontSize: 16.0,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.34,
                                                  color: selectedTab.value == 0 ? primaryColor.value : placeholderColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            selectedTab.value = 1;
                                            getNfts();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border(
                                                bottom: BorderSide(width: 0.5, color: selectedTab.value == 1 ? primaryColor.value : placeholderColor),
                                              ),
                                            ),
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              "Nfts",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "sfpro",
                                                  fontSize: 16.0,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.34,
                                                  color: selectedTab.value == 1 ? primaryColor.value : placeholderColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                if (selectedTab.value == 0) coinsView(),
                                if (selectedTab.value == 1) nftView()
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 170,
                      left: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          width: Get.width - 32,
                          height: 80,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: cardColor.value, boxShadow: appShadow),
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          child: Row(
                            children: [
                              _dashBTns(
                                  svg: 'send',
                                  btnText: 'Withdraw',
                                  onTap: () {
                                    print('==============');
                                    //Get.to(ChooseToken(fromPage: 'send',));
                                    CommonWidgets().selectWithdrawBottomSheet(context);
                                  }),
                              _dashBTns(
                                  svg: 'recieve',
                                  btnText: 'Receive',
                                  onTap: () {
                                    var address;
                                    Get.to(ChooseToken(
                                      fromPage: 'receive',
                                    ))?.then((value) {
                                      if (value != null) {
                                        address = (value.networkName == 'Tron')
                                            ? (appController.userBalance.value.wallet?.tronAddress ?? '')
                                            : (value.networkName == 'Bitcoin' || value.networkName == 'Bitcoin (Testnet)')
                                                ? (appController.userBalance.value.wallet?.btcAddress ?? '')
                                                : (appController.userBalance.value.wallet?.evmAddress ?? '');
                                        print(value.symbol);
                                        _qrBottomSheeet(context, address, value.symbol);
                                      }
                                    });
                                  }),
                              _dashBTns(
                                  svg: 'History',
                                  btnText: 'History',
                                  onTap: () {
                                    Get.to(History());
                                  }),
                              _dashBTns(
                                  svg: 'buy',
                                  btnText: 'Buy',
                                  onTap: () {
                                    Get.to(ChooseToken(
                                      fromPage: 'buy',
                                    ));
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget coinsView() {
    return Expanded(
      child: appController.getBalanceLoader.value == true
          ? ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16, bottom: 16),
              itemCount: 8,
              itemBuilder: (BuildContext context, int index) => Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(0.25),
                highlightColor: Colors.grey.withOpacity(0.5),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  width: Get.width,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey,
                  ),
                ),
              ),
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 16);
              },
            )
          : AnimationLimiter(
              child: ListView.builder(
                itemCount: appController.userBalance.value.balance?.length ?? 0,
                padding: EdgeInsets.only(top: 10, bottom: 40),
                itemBuilder: (context, i) {
                  bool inc = (appController.userBalance.value.balance?[i].priceChange ?? 0) > 0 ? true : false;
                  return AnimationConfiguration.staggeredList(
                    position: i,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 10.0,
                      duration: Duration(milliseconds: 1000),
                      child: FadeInAnimation(
                        child: _coinRow(
                          coinName: '${appController.userBalance.value.balance?[i].symbol ?? ''}',
                          priceInUSD: '${UtilService().toFixed2DecimalPlaces((appController.userBalance.value.balance?[i].price ?? 0).toString())}',
                          imgName: '${appController.userBalance.value.balance?[i].logoUrl}',
                          percentage: '${UtilService().toFixed2DecimalPlaces((appController.userBalance.value.balance?[i].priceChange ?? 0).toString(), decimalPlaces: 2)}',
                          amountInEth: '${UtilService().toFixed2DecimalPlaces((appController.userBalance.value.balance?[i].balance ?? 0).toString(), decimalPlaces: 4)}',
                          amountInUSD:
                              '${UtilService().toFixed2DecimalPlaces((appController.userBalance.value.balance?[i].balanceInLocalCurrency ?? 0).toString(), decimalPlaces: 4)}',
                          increment: inc,
                          token: appController.userBalance.value.balance?[i],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget nftView() {
    return Expanded(
      child: appController.getNftsLoader.value == true
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16, bottom: 16),
              itemCount: 8,
              itemBuilder: (BuildContext context, int index) => Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(0.25),
                highlightColor: Colors.grey.withOpacity(0.5),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  // width: Get.width,
                  // height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          : AnimationLimiter(
              child: GridView.builder(
                controller: _nftGridScrollController,
              itemCount: appController.allNFTsList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(NftDetail(
                      url: appController.allNFTsList[index].imageUrl ?? '',
                      nft: appController.allNFTsList[index],
                    ))!.then((value) {
                      print('value => $value');
                      if(value == 'sent'){
                        appController.allNFTsList.removeAt(index);
                        appController.allNFTsList.refresh();
                      }
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Expanded(
                            child: Hero(
                          tag: appController.allNFTsList[index].id!,
                          child: Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: cardColor.value,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: appController.allNFTsList[index].imageUrl ?? '',
                              fit: BoxFit.cover,
                            ),
                            clipBehavior: Clip.antiAlias,
                          ),
                        )),
                        Container(
                          height: 61,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: cardColor.value,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(18), bottomRight: Radius.circular(18)),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${appController.allNFTsList[index].name}",
                                style: TextStyle(
                                    fontFamily: "sfpro",
                                    fontSize: 12.0,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.24,
                                    color: inputFieldTextColor.value),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "#${appController.allNFTsList[index].tokenId}",
                                      style: TextStyle(
                                          fontFamily: "sfpro",
                                          fontSize: 12.0,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.24,
                                          color: inputFieldTextColor.value),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),
    );
  }

  Widget _coinRow({String? coinName, String? amountInEth, String? amountInUSD, String? percentage, String? priceInUSD, String? imgName, required bool increment, Balance? token}) {
    return GestureDetector(
      onTap: () {
        //Get.to(CoinHistory(token: token!,));
      },
      child: Container(
        width: Get.width,
        padding: EdgeInsets.symmetric(vertical: 10),
        color: Colors.transparent,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: lightColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: imgName ?? '',
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    clipBehavior: Clip.antiAlias,
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '$coinName',
                            style: TextStyle(
                              fontFamily: 'sfpro',
                              color: headingColor.value,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              letterSpacing: 0.37,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            '${appController.user.value.currency?.symbol}$priceInUSD',
                            style: TextStyle(
                              fontFamily: 'sfpro',
                              color: placeholderColor,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              letterSpacing: 0.44,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          increment == true
                              ? Text(
                                  '+ $percentage%',
                                  style: TextStyle(fontFamily: 'sfpro', fontWeight: FontWeight.w400, fontSize: 13.0, letterSpacing: 0.44, color: greenCardColor.value),
                                )
                              : Text(
                                  ' $percentage%',
                                  style: TextStyle(fontFamily: 'sfpro', fontWeight: FontWeight.w400, fontSize: 13.0, letterSpacing: 0.44, color: redCardColor.value),
                                ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        '$amountInEth',
                        style: TextStyle(
                          fontFamily: 'sfpro',
                          color: headingColor.value,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          letterSpacing: 0.37,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${appController.user.value.currency?.symbol}$amountInUSD',
                    style: TextStyle(
                      fontFamily: 'sfpro',
                      color: placeholderColor,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                      letterSpacing: 0.44,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dashBTns({String? svg, String? btnText, Function? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset(
                      'assets/svgs/$svg.svg',
                      color: inputFieldTextColor.value,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '$btnText',
                style: TextStyle(
                  fontFamily: 'sfpro',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                  letterSpacing: 0.37,
                  color: inputFieldTextColor.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _qrBottomSheeet(BuildContext context, String address, String coinSymbol) {
    return Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      Container(
        padding: EdgeInsets.all(20),
        height: Get.height * 0.63,
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
                  "Receive",
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
              height: 40,
            ),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: lightColor),
              padding: EdgeInsets.all(6),
              child: QrImageView(
                data: "$address",
                version: QrVersions.auto,
                size: 200.0,
                // backgroundColor: headingColor.value,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Send only ($coinSymbol) to this address.\nSending any other coins may result in permanent loss.",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'sfpro', fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 11.0, letterSpacing: 0.44, color: placeholderColor),
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                UtilService().copyToClipboard(address);
              },
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: bSheetbtnColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageIcon(
                      AssetImage("assets/imgs/Icons1.png"),
                      color: primaryColor.value,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      '${address.substring(0, 5) + '...' + address.substring(address.length - 4)}',
                      style:
                          TextStyle(fontFamily: 'sfpro', fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 14.0, letterSpacing: 0.44, color: primaryColor.value),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  onRefresh() async {
    appController.getBalanceLoader.value = true;
    appController.userWalletsLoader.value = true;
    getUserData();
    if(selectedTab.value == 1){
      getNfts();
    }
  }
}
