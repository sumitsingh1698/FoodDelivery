// class BucketDetailsResponse {
//   List<String> restImage;
//   int count;
//   List<Order> order;
//   bool bucketAccepted;

//   BucketDetailsResponse(
//       {this.restImage, this.count, this.order, this.bucketAccepted});

//   BucketDetailsResponse.fromJson(Map<String, dynamic> json) {
//     restImage = json['rest_image'].cast<String>();
//     count = json['count'];
//     if (json['order'] != null) {
//       order = new List<Order>();
//       json['order'].forEach((v) {
//         order.add(new Order.fromJson(v));
//       });
//     }
//     bucketAccepted = json['is_driver_accepted'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['rest_image'] = this.restImage;
//     data['count'] = this.count;
//     if (this.order != null) {
//       data['order'] = this.order.map((v) => v.toJson()).toList();
//     }
//     data['bucket_accepted'] = this.bucketAccepted;
//     return data;
//   }
// }

class Order {
  int count;
  String restaurantImage;
  String userPhone;
  String restaurantPhone;
  bool isDeliveredOrder;
  double rewardDelistaff;
  String pickUpAddress;
  String deliveryAddress;
  String orderNo;
  String slottime;
  User user;
  String id;
  List<Orderitems> orderitems;
  double grandtotal;
  String paymentMethod;
  String restaurantName;
  bool isPickupStarted;
  bool isOrderCancel;
  bool bucketAccepted;

  Order(
      {this.restaurantImage,
      this.userPhone,
      this.restaurantPhone,
      this.isDeliveredOrder,
      this.rewardDelistaff,
      this.pickUpAddress,
      this.deliveryAddress,
      this.orderNo,
      this.slottime,
      this.user,
      this.id,
      this.orderitems,
      this.grandtotal,
      this.paymentMethod,
      this.restaurantName,
      this.isPickupStarted,
      this.isOrderCancel});

  Order.fromJson(Map<String, dynamic> json) {
    restaurantImage = json['restaurant_image'];
    userPhone = json['user_phone'];
    restaurantPhone = json['restaurant_phone'];
    isDeliveredOrder = json['is_delivered_order'];
    rewardDelistaff = json['reward_delistaff'];
    pickUpAddress = json['pick_up_address'];
    deliveryAddress = json['delivery_address'];
    orderNo = json['order_no'];
    slottime = json['slottime'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    id = json['id'];
    if (json['orderitems'] != null) {
      orderitems = new List<Orderitems>();
      json['orderitems'].forEach((v) {
        orderitems.add(new Orderitems.fromJson(v));
      });
    }
    grandtotal = json['grandtotal'];
    paymentMethod = json['payment_method'];
    restaurantName = json['restaurant_name'];
    isPickupStarted = json['is_pickup_started'];
    isOrderCancel = json['is_order_cancel'];
    bucketAccepted = json['is_driver_accepted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_image'] = this.restaurantImage;
    data['user_phone'] = this.userPhone;
    data['restaurant_phone'] = this.restaurantPhone;
    data['is_delivered_order'] = this.isDeliveredOrder;
    data['reward_delistaff'] = this.rewardDelistaff;
    data['pick_up_address'] = this.pickUpAddress;
    data['delivery_address'] = this.deliveryAddress;
    data['order_no'] = this.orderNo;
    data['slottime'] = this.slottime;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['id'] = this.id;
    if (this.orderitems != null) {
      data['orderitems'] = this.orderitems.map((v) => v.toJson()).toList();
    }
    data['grandtotal'] = this.grandtotal;
    data['payment_method'] = this.paymentMethod;
    data['restaurant_name'] = this.restaurantName;
    data['is_pickup_started'] = this.isPickupStarted;
    data['is_order_cancel'] = this.isOrderCancel;
    return data;
  }
}

class User {
  String profilePic;
  String name;
  String phone;

  User({this.profilePic, this.name, this.phone});

  User.fromJson(Map<String, dynamic> json) {
    profilePic = json['profile_pic'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_pic'] = this.profilePic;
    data['name'] = this.name;
    data['phone'] = this.phone;
    return data;
  }
}

class Orderitems {
  String itemName;
  double itemPrice;
  int count;
  String size;

  Orderitems({this.itemName, this.itemPrice, this.count, this.size});

  Orderitems.fromJson(Map<String, dynamic> json) {
    itemName = json['item_name'];
    itemPrice = json['item_price'];
    count = json['count'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_name'] = this.itemName;
    data['item_price'] = this.itemPrice;
    data['count'] = this.count;
    data['size'] = this.size;
    return data;
  }
}
