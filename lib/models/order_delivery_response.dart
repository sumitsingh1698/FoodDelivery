class OrderDeliveryResponse {
  int reward;
  bool lastOrder;
  bool status;
  String message;

  OrderDeliveryResponse(
      {this.reward, this.lastOrder, this.status, this.message});

  OrderDeliveryResponse.fromJson(Map<String, dynamic> json) {
    reward = json['reward'];
    lastOrder = json['last_order'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reward'] = this.reward;
    data['last_order'] = this.lastOrder;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
