[
    {
        capped: true,
        size: 100000,
        max: 5000,
        validator: {
            $jsonSchema: {
                bsonType: 'Object',
                required: ['Ecode', 'Ename'],
                properties: {
                    Ecode: {bsonType: 'int'},
                    Ename: {bsonType: 'string'},
                    Age: {bsonType: 'int'},
                    City: {bsonType: 'string'}
                }
            }
        }
    }
]
