import { MongoClient } from "mongodb";
import * as dotenv from "dotenv";

const url = "mongodb://127.0.0.1:27017/";

dotenv.config();

const getClientConnection = async () => {
  const client = new MongoClient(
    // `mongodb://${process.env.DB_USER}:${process.env.DB_PASS}@${process.env.DB_HOST}:${process.env.DB_PORT}`
    url
  );
  await client.connect();

  return client;
};

const getDb = async () => {
  const client = await getClientConnection();

  const db = client.db(process.env.MONGO_DB);
  // const db = client.db("zaychinclonedb");

  console.log("db connected");
  return db;
};

// const db = await getDb();

export { getClientConnection, getDb };
