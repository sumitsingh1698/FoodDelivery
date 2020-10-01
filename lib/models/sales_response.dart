class SalesResponse {
  List<Buckets> buckets;
  String text;
  String endOfWeek;
  String startOfWeek;
  int totalReward;

  SalesResponse(
      {this.buckets,
      this.text,
      this.endOfWeek,
      this.startOfWeek,
      this.totalReward});

  SalesResponse.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      buckets = new List<Buckets>();
      json['orders'].forEach((v) {
        buckets.add(new Buckets.fromJson(v));
      });
    }
    text = json['text'];
    endOfWeek = json['end_of_week'];
    startOfWeek = json['start_of_week'];
    totalReward = json['total_reward'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.buckets != null) {
      data['buckets'] = this.buckets.map((v) => v.toJson()).toList();
    }
    data['text'] = this.text;
    data['end_of_week'] = this.endOfWeek;
    data['start_of_week'] = this.startOfWeek;
    data['total_reward'] = this.totalReward;
    return data;
  }
}

class Buckets {
  List<Order> order;
  double reward;
  String bucketAcceptedTime;
  String id;

  Buckets({this.order, this.reward, this.bucketAcceptedTime, this.id});

  Buckets.fromJson(Map<String, dynamic> json) {
    if (json['orderitems'] != null) {
      order = new List<Order>();
      json['orderitems'].forEach((v) {
        order.add(new Order.fromJson(v));
      });
    }
    reward = json['reward'] == 0 ? 0 : json['reward'];
    bucketAcceptedTime = json['order_accepted_time'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.order != null) {
      data['order'] = this.order.map((v) => v.toJson()).toList();
    }
    data['reward'] = this.reward;
    data['bucket_accepted_time'] = this.bucketAcceptedTime;
    data['id'] = this.id;
    return data;
  }
}

class Order {
  String orderNo;
  String restaurantName;

  Order({this.orderNo, this.restaurantName});

  Order.fromJson(Map<String, dynamic> json) {
    orderNo = json['order_no'];
    restaurantName = json['restaurant_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_no'] = this.orderNo;
    data['restaurant_name'] = this.restaurantName;
    return data;
  }
}
