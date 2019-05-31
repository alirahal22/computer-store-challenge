const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

const computerRoutes = require('./api/routes/computers')

mongoose.connect('mongodb://localhost/computer_store', { useNewUrlParser: true }, (error) => {
    if (error) throw error;
    console.log('Connected to MongoDB');
})


const app = express();
app.use(bodyParser.urlencoded({
    extended: false
}));

app.use(bodyParser.json()); 

// app.use((req, res) => {
    // res.header("Access-Control-Allow-Origin", "*");
    // res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization");
    // if (req.method === "OPTIONS"){
    //     res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, PATCH, DELETE');
    //     return res.status(200).json({});
    // }
// });

app.use('/computers', computerRoutes);


app.use((req, res, next) => {
    const error = new Error('Not Found');
    error.status = 404;
    next(error);
});

app.use((error, req, res, next) => {
    res.status(error.status || 500);
    res.json({
        error: {
            message: error.message
        }
    })
});
module.exports = app;