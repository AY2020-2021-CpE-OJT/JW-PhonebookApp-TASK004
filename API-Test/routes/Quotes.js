const express = require('express');
const router = express.Router();
const Quote = require('../models/Quotes');


//Get all routes
router.get('/', (req,res) => {
    //console.log("Get all routes...");
    res.send("Get all routes");
});

//Create a new Quote
router.post('/new', async (req, res) => {
    const newQuote = new Quote(req.body);
   
    const savedQuote = await newQuote.save();

    res.json(savedQuote);
   // res.send("Create New Quote");
});

module.exports = router;