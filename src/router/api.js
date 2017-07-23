const { getAllImages, getSingleImage } = require('./../utils/images.js');

module.exports = {
  method: 'GET',
  path: '/imgs/{type}',
  handler: (req, reply) => {
    const type = {
      all: 'all',
      single: 'single',
    }[req.params.type];

    switch (type) {
      case 'all':
        getAllImages((err, list) => {
          if (err) return reply({ error: 'ERROR' });
          reply(list);
        });
        break;
      case 'single':
        getSingleImage(req.query.image, (err, list) => {
          if (err) return reply({ error: 'ERROR' });
          reply(list);
        });
        break;
      default:
        reply({ error: 'ERROR' });
    }
  },
};
