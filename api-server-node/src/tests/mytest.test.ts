import { Db } from "mongodb";
import { MongoClient } from "mongodb";
import dotenv from "dotenv";

let db: Db, client: MongoClient;

beforeAll(async () => {
  dotenv.config();
  const uri = process.env.TEST_MONGO_URI || "mongodb://127.0.0.1:27017/";
  client = new MongoClient(uri);

  await client.connect();
  console.log("testdb=", process.env.TEST_MONGO_DB);
  db = client.db(process.env.TEST_MONGO_DB);
});

afterAll(async () => {
  await client.close();
});

test("mytest", async () => {
  const collections = await db.listCollections().toArray();
  console.log(collections);

  expect(1).toBe(1);
});
