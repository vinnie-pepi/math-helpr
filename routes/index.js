var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Math Helper' });
});
router.get('/geoservices', function(req, res, next) {
  res.render('geoservices');
});
module.exports = router;
