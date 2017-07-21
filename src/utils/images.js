const fs = require('fs');

module.exports = {
  getAllImages: callback => {
    fs.readdir('./public/images', (err, list) => {
      if (err) return callback(err);

      callback(null, list);
    });
  },
  getSingleImage: (imageDirectory, callback) => {
    fs.readdir(`./public/images/${imageDirectory}`, (err, list) => {
      if (err) return callback(err);

      callback(null, list);
    });
  },
};
