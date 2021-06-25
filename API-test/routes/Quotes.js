const express = require('express');
const router = express.Router();
const Quote = require('../models/Quotes');


//Get all routes
router.get('/', async (req,res) => {
    const quotes = await Quote.find();
    res.json(quotes);
    //console.log("Get all routes...");
    //res.send("Get all routes");
});

//Create a new Quote
router.post('/new', async (req, res) => {
    const newQuote = new Quote(req.body);
   
    const savedQuote = await newQuote.save();

    res.json(savedQuote);
   // res.send("Create New Quote");
});

//Get  specific Quote
router.get('/get/:id', async (req,res) =>{
    const q = await Quote.findById({_id: req.params.id});
    res.json(q);
});

//Delete Quote 
router.delete('/delete/:id', async (req,res) => {
    const result = await Quote.findByIdAndDelete({_id: req.params.id});
    res.json(result);
});

//Update a Quote
router.patch('/update/:id', async (req, res) => {
    const patch = await Quote.updateOne({_id: req.params.id}, {$set: req.body});
    res.json(patch);
});

//Get Random Quote
router.get('/random', async (req, res) => {
    const count = await Quote.countDocuments();
    
    const random = Math.floor(Math.random() * count);
    const q = await Quote.findOne().skip(random);

    res.json(q);
});

module.exports = router;