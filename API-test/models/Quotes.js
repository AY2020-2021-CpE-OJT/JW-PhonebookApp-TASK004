const mongoose = require('mongoose');

const QuoteSchema = new mongoose.Schema({
    content: String,
    author: String,
    date: String
});

module.exports = mongoose.model('Quote', QuoteSchema);