const express = require('express');
const router = express.Router();

const mongoose = require('mongoose');
const Computer = require('../../models/computer');

router.get('/', (req, res) => {
    Computer.find()
        .select('_id name price modelNumber imagePath cpu rams brand')
        .exec()
        .then(docs => {
            res.status(200).json(docs.map(doc => {
                return {
                    _id: doc._id,
                    name: doc.name,
                    price: doc.price,
                    modelNumber: doc.modelNumber,
                    imagePath: "some_image_path",
                    cpu: doc.cpu,
                    rams: doc.rams,
                    brand: doc.brand,
                    request: {
                        type: 'GET',
                        url: 'http://localhost:3000/computers/' + doc._id
                    }
                }
            }));
        })
        .catch(error => {
            res.status(500).json({error: error})
        });
});
router.post('/', (req, res) => {
    const computer = new Computer({
        _id: new mongoose.Types.ObjectId(),
        name: req.body.name,
        price: req.body.price,
        modelNumber: req.body.modelNumber,
        imagePath: "some_image_path",
        cpu: req.body.cpu,
        rams: req.body.rams,
        brand: req.body.brand
    })
    computer.save()
        .then(result => {
            res.status(200).json({
                message: 'Added a new Computer',
                computer: {
                    _id: result._id,
                    name: result.name,
                    price: result.price,
                    modelNumber: result.modelNumber,
                    imagePath: "some_image_path",
                    cpu: result.cpu,
                    rams: result.rams,
                    brand: result.brand,
                    request: {
                        type: 'GET',
                        url: 'http://localhost:3000/computers/' + result._id
                    }
                }
            });
        })
        .catch(error => {
            res.status(500).json({error: error});
        });
    
});

router.get('/:computerId', (req, res) => {
    const id = req.params.computerId;
    Computer.findById(id)
        .exec()
        .then(doc => {
            if (doc) {
                res.status(200).json(doc);
            } else {
                res.status(404).json({
                    message: "The requested computer doesn't exist"
                })
            }
            
        })
        .catch(error => {
            res.status(500).json({error: error})
        }); 
});

router.patch('/:computerId', (req, res) => {
    const id = req.params.computerId;
    const updateOps = {};
    for(const ops of req.body){
        updateOps[ops.propName] = ops.value;
    } //the body has to be an array
    //example 
    // [
    //     {"propName": "rams", "value": "20"},
    //     {"propName": "name", "value": "potato"}
    // ]

    Computer.update({_id: id}, { $set: updateOps})
        .exec()
        .then(result => {
            res.status(200).json({
                message: 'Computer Updated',
                request: {
                    type: 'GET',
                    url: 'http://localhost:3000/computers/' + result._id
                }
            });
        })
        .catch(error => {
            res.status(500).json({error: error})
        });
});

router.delete('/:computerId', (req, res) => {
    const id = req.params.computerId;
    Computer.remove( {_id: id} )
        .exec()
        .then(result => { 
            res.status(200).json({
                message: 'Computer Deleted'
            });
        })
        .catch(error => {
            res.status(500).json({error: error});
        })
});

module.exports = router;