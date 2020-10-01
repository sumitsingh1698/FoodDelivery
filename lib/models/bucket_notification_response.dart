class BucketNotificationResponse {
  int count;
  String deliNotiUpto;
  String currenttimep;
  List<Order> bucket;
  int sec;

  BucketNotificationResponse(
      {this.count,
      this.deliNotiUpto,
      this.currenttimep,
      this.bucket,
      this.sec});

  BucketNotificationResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    deliNotiUpto = json['deli_noti_upto'];
    currenttimep = json['currenttimep'];
    if (json['order'] != null) {
      bucket = new List<Order>();
      json['order'].forEach((v) {
        bucket.add(new Order.fromJson(v));
      });
    }
    sec = json['sec'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['deli_noti_upto'] = this.deliNotiUpto;
    data['currenttimep'] = this.currenttimep;
    if (this.bucket != null) {
      data['order'] = this.bucket.map((v) => v.toJson()).toList();
    }
    data['sec'] = this.sec;
    return data;
  }
}

class Order {
  List<OrderItems> orderitems;
  String id;
  DeliLocation deliverLocation;
  String slottime;
  bool bucketAccepted;
  PickUpLocation pickUpLocation;
  String restaurantName;

  Order({this.orderitems, this.id, this.slottime, this.bucketAccepted});

  Order.fromJson(Map<String, dynamic> json) {
    if (json['orderitems'] != null) {
      orderitems = new List<OrderItems>();
      json['orderitems'].forEach((v) {
        orderitems.add(new OrderItems.fromJson(v));
      });
    }
    id = json['id'];
    slottime = json['slottime'];
    bucketAccepted = json['is_driver_accepted'];
    pickUpLocation = json['pick_up_location'] != null
        ? new PickUpLocation.fromJson(json['pick_up_location'])
        : null;
    restaurantName = json['restaurant_name'];
    deliverLocation = DeliLocation.fromJson(json['delivery_location']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // if (this.order != null) {
    //   data['order'] = this.order.map((v) => v.toJson()).toList();
    // }
    data['id'] = this.id;
    data['slottime'] = this.slottime;
    data['is_driver_accepted'] = this.bucketAccepted;
    if (this.pickUpLocation != null) {
      data['pick_up_location'] = this.pickUpLocation.toJson();
    }
    data['restaurant_name'] = this.restaurantName;
    return data;
  }
}

class OrderItems {
  String itemname;
  double itemprice;
  int itemcount;
  String itemsize;

  OrderItems({this.itemname, this.itemprice, this.itemcount, this.itemsize});

  OrderItems.fromJson(Map<String, dynamic> json) {
    itemname = json['item_name'];
    itemprice = json['item_price'];
    itemcount = json['count'];
    itemsize = json['size'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();

  //   return data;
  // }
}

class PickUpLocation {
  String long;
  String place;
  String lat;

  PickUpLocation({this.long, this.place, this.lat});

  PickUpLocation.fromJson(Map<String, dynamic> json) {
    long = json['long'];
    place = json['place'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['long'] = this.long;
    data['place'] = this.place;
    data['lat'] = this.lat;
    return data;
  }
}

class DeliLocation {
  String long;
  String place;
  String lat;

  DeliLocation({this.long, this.place, this.lat});

  DeliLocation.fromJson(Map<String, dynamic> json) {
    long = json['long'];
    place = json['place'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['long'] = this.long;
    data['place'] = this.place;
    data['lat'] = this.lat;
    return data;
  }
}
