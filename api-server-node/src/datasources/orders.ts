import { MongoDataSource } from "apollo-datasource-mongodb";
import { ObjectId } from "mongodb";

class Orders extends MongoDataSource<any, any> {
  async getAllOrders(status) {
    const orders = await this.collection
      .find(status ? { status } : {})
      .toArray();
    // console.log(orders);

    return orders;
  }

  async confirmOrder(orderId) {
    console.log("orderId=", orderId);
    const result = await this.collection.updateOne(
      { _id: new ObjectId(orderId) },
      {
        $set: {
          status: "confirmed",
        },
      }
    );
    console.log("result=", result);

    return {
      status: result.matchedCount > 0 ? "success" : "failed",
    };
  }

  async getOrderById(id) {
    if (typeof id == "string") {
      const order = await this.collection.findOne({ id });
      return order;
    }
    return null;
  }

  getProductsFromOrder(order) {
    // console.log('listofProducts=', order.products)
    const listOfProducts = order.products;
    return listOfProducts;
  }

  getUserFromOrder(order) {
    const orderUser = order.user;
    return {
      name: orderUser.name,
      phNumber: orderUser.phNumber,
    };
  }
  async addOrder({ orderInput }) {
    console.log("orderInput=", orderInput);
    const result = await this.collection.insertOne({
      status: "pending",
      ...orderInput,
    });
    console.log("result=", result);
    const order = await this.collection.findOne({
      _id: result.insertedId,
    });
    console.log("addOrder=", order);
    return order;
  }
}

export default Orders;
