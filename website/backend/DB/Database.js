import mongoose from "mongoose";

export const connectDB = async (req, res) => {
    const db = "mongodb://10.0.1.4:27017/MainData";

    const {connection} = await mongoose.connect(db, { useNewUrlParser: true });

    console.log(`MongoDB Connected to ${connection.host}`);

}
