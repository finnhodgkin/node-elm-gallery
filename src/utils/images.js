const fs = require('fs');

module.exports = {
  getAllImages: callback => {
    console.log('happening');
    fs.readdir('./public/images', (err, list) => {
      if (err) return callback(err);

      callback(null, list.filter(file => file.split('.').length === 1));
    });
  },
  getSingleImage: (imageDirectory, callback) => {
    console.log('happening2');
    fs.readdir(`./public/images/${imageDirectory}`, (err, list) => {
      if (err) return callback(err);

      callback(null, list);
    });
  },
};
