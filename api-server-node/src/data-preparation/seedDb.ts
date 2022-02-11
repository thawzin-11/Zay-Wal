import users from "./users.js";
import orders from "./orders.js";
import addresses from "./addresses.js";
import products from "./products.js";
import { Db } from "mongodb";

async function seedProducts(db: Db, clearCollection = true) {
  if (clearCollection) {
    await db.collection("products").deleteMany({});
  }

  await db.collection("products").insertMany(products);
}

async function seedDb(db: Db) {
  // const db = await getDb();

  //purge previous data
  await db.collection("users").deleteMany({});
  await db.collection("orders").deleteMany({});

  //add new data
  await seedProducts(db);
  await db.collection("users").insertMany(users);
  await db.collection("orders").insertMany(orders);

  const user = await db.collection("users").findOne({
    _id: "61824e0b3f25fcf95a389171",
  });
  console.log("user=", user);
}

export default seedDb;
