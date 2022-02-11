import { Db } from "mongodb";
import { MongoClient } from "mongodb";
import dotenv from "dotenv";
import seedDbFromSrc from "../src/data-preparation/seedDb";

let db: Db, client: MongoClient;

dotenv.config();
const uri = process.env.MONGO_URI || "mongodb://127.0.0.1:27017/";
client = new MongoClient(uri);

async function seedDb() {
  await client.connect();
  console.log("testdb=", process.env.TEST_MONGO_DB);
  db = client.db(process.env.TEST_MONGO_DB);

  await seedDbFromSrc(db);

  // const collections = await db.listCollections().toArray();
  // console.log(collections);

  await client.close();
}

seedDb()
  .then(() => {
    console.log("db seeded(new)");
  })
  .catch((e) => {
    console.log("error running seeddb. error=", e);
  });
