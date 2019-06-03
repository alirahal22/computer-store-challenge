const express = require('express');
const router = express.Router();

const mongoose = require('mongoose');
const Computer = require('../../models/computer');

//get all computers
router.get('/', (req, res) => {
    Computer.find()
        .select('name price modelNumber imageURL cpu rams brand')
        .exec()
        .then(docs => {
            console.log(docs)
            res.status(200).json(docs.map(doc => {
                return {
                    _id: doc._id,
                    name: doc.name,
                    price: doc.price,
                    modelNumber: doc.modelNumber,
                    imageURL: "some_image_path",
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

//get different cpus available
router.get('/cpus', (req, res) => {
    console.log('Fetching CPUs')
    Computer.find()
        .exec()
        .then(docs => {
            const items = []
            for (doc of docs){
                if (!items.includes(doc.cpu)) {
                    items.push(doc.cpu)
                }
            }
            res.status(200).json(items)
        })
        .catch(error => {
            res.status(500).json({error: error})
        });
});
//get different brands available
router.get('/brands', (req, res) => {
    console.log('Fetching brands')
    Computer.find()
        .exec()
        .then(docs => {
            const items = []
            for (doc of docs){
                if (!items.includes(doc.brand)) {
                    items.push(doc.brand)
                }
            }
            res.status(200).json(items)
        })
        .catch(error => {
            res.status(500).json({error: error})
        });
});

router.post('/search/filter/page/:pageNumber', (req, res) => {
    console.log("Filtering computers")
    const filters = {}
    for (filter of req.body) {
        //later get value type for filtering with more properties
        if (filter.propName === "rams") {
            filters[filter.propName] = filter.value
        } else {
            filters[filter.propName] = new RegExp(filter.value, 'i')
        }
    }
    console.log(filters)
    const pageSize = 5
    const pageNumber = req.params.pageNumber
    Computer.find( filters )
        .sort('_id')
        .skip(pageSize * (pageNumber - 1))
        .limit(pageSize)
        .exec()
        .then(docs => {
            res.status(200).json(docs.map(doc => {
                return {
                    _id: doc._id,
                    name: doc.name,
                    price: doc.price,
                    modelNumber: doc.modelNumber,
                    imageURL: "some_image_path",
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

router.get('/search/:searchString/page/:pageNumber', (req, res) => {
    const searchString = req.params.searchString
    const searchKey = new RegExp(searchString, 'i')
    const pageSize = 5
    const pageNumber = req.params.pageNumber
    Computer.find({name: searchKey})
        .sort('_id')
        .skip(pageSize * (pageNumber - 1))
        .limit(pageSize)
        .exec()
        .then(docs => {
            res.status(200).json(docs.map(doc => {
                return {
                    _id: doc._id,
                    name: doc.name,
                    price: doc.price,
                    modelNumber: doc.modelNumber,
                    imageURL: "some_image_path",
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
        name: capitalizeFirstLetter(req.body.name),
        price: req.body.price,
        modelNumber: capitalizeFirstLetter(req.body.modelNumber),
        imageURL: "some_image_path",
        cpu: req.body.cpu,
        rams: req.body.rams,
        brand: capitalizeFirstLetter(req.body.brand)
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
                    imageURL: "some_image_path",
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

router.get('/page/:pageNumber', (req, res) => {
    const pageSize = 5
    const pageNumber = req.params.pageNumber
    Computer.find()
        .sort('_id')
        .skip(pageSize * (pageNumber - 1))
        .limit(pageSize)
        .select('name price modelNumber imageURL cpu rams brand')
        .exec()
        .then(docs => {
            res.status(200).json(docs.map(doc => {
                return {
                    _id: doc._id,
                    name: doc.name,
                    price: doc.price,
                    modelNumber: doc.modelNumber,
                    imageURL: "some_image_path",
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


function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

module.exports = router;