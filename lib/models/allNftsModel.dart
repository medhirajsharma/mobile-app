class AllNftsModel {
  String? tokenId;
  String? contractAddress;
  num? iV;
  num? amount;
  String? createdAt;
  String? imageUrl;
  String? name;
  String? networkId;
  String? owner;
  String? symbol;
  String? tokenUri;
  String? type;
  String? updatedAt;
  String? userId;
  String? walletId;
  Network? network;
  String? id;

  AllNftsModel(
      {this.tokenId,
        this.contractAddress,
        this.iV,
        this.amount,
        this.createdAt,
        this.imageUrl,
        this.name,
        this.networkId,
        this.owner,
        this.symbol,
        this.tokenUri,
        this.type,
        this.updatedAt,
        this.userId,
        this.walletId,
        this.network,
        this.id});

  AllNftsModel.fromJson(Map<String, dynamic> json) {
    tokenId = json['tokenId'];
    contractAddress = json['contractAddress'];
    iV = json['__v'];
    amount = json['amount'];
    createdAt = json['createdAt'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    networkId = json['networkId'];
    owner = json['owner'];
    symbol = json['symbol'];
    tokenUri = json['tokenUri'];
    type = json['type'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
    walletId = json['walletId'];
    network =
    json['network'] != null ? new Network.fromJson(json['network']) : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tokenId'] = this.tokenId;
    data['contractAddress'] = this.contractAddress;
    data['__v'] = this.iV;
    data['amount'] = this.amount;
    data['createdAt'] = this.createdAt;
    data['imageUrl'] = this.imageUrl;
    data['name'] = this.name;
    data['networkId'] = this.networkId;
    data['owner'] = this.owner;
    data['symbol'] = this.symbol;
    data['tokenUri'] = this.tokenUri;
    data['type'] = this.type;
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    data['walletId'] = this.walletId;
    if (this.network != null) {
      data['network'] = this.network!.toJson();
    }
    data['id'] = this.id;
    return data;
  }
}

class Network {
  String? name;
  String? symbol;
  String? logoUrl;
  String? rpcUrl;
  int? chainId;
  String? nativeCoinAddress;
  String? networkName;
  String? networkType;
  bool? isMainnet;
  bool? isDeleted;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? id;

  Network(
      {this.name,
        this.symbol,
        this.logoUrl,
        this.rpcUrl,
        this.chainId,
        this.nativeCoinAddress,
        this.networkName,
        this.networkType,
        this.isMainnet,
        this.isDeleted,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.id});

  Network.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    symbol = json['symbol'];
    logoUrl = json['logoUrl'];
    rpcUrl = json['rpcUrl'];
    chainId = json['chainId'];
    nativeCoinAddress = json['nativeCoinAddress'];
    networkName = json['networkName'];
    networkType = json['networkType'];
    isMainnet = json['isMainnet'];
    isDeleted = json['isDeleted'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    data['logoUrl'] = this.logoUrl;
    data['rpcUrl'] = this.rpcUrl;
    data['chainId'] = this.chainId;
    data['nativeCoinAddress'] = this.nativeCoinAddress;
    data['networkName'] = this.networkName;
    data['networkType'] = this.networkType;
    data['isMainnet'] = this.isMainnet;
    data['isDeleted'] = this.isDeleted;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}