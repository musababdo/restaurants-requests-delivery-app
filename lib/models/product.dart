class Product{

  String id;
  String name;
  String image;
  String price;
  int quantity;

  Product(this.id,this.name,this.image,this.price,this.quantity);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['quantity'] = this.quantity;
    return data;
  }

  Product.fromJson(Map<String, dynamic> json) {
    //this.id       = json['id'];
    this.name     = json['name'];
    this.image    = json['image'];
    this.quantity = json['quantity'];
  }
}