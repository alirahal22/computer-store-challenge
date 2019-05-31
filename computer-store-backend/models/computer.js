const mongoose = require('mongoose');

const computerSchema = mongoose.Schema({
    _id: mongoose.Schema.Types.ObjectId,
    name: {type: String, required: true},
    price: {type: Number, required: true},
    modelNumber: {type: String, required: true},
	imagePath: String,
	cpu: {type: String, required: true},
	rams: {type: Number, required: true},
	brand: {type: String, required: true},
});

module.exports = mongoose.model('Computer', computerSchema);