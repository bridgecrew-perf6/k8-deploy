const app = require('../app');
const request = require('supertest');
const expect = require('chai').expect;

describe('Default route', () => {
  it('should respond with the right message', (done) => {
    request(app)
      .get('/')
      .set('Content-Type', 'application/json')
      .expect('Content-Type', /json/)
      .expect(200, function(err, res) {
        if (err) { return done(err); }

        expect(res.body).to.deep.equal({ message: 'This works!' });

        done();
    });
  });
});
