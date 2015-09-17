import { Client } from 'pg';
import denodeify from 'denodeify';
import runner from './insert';

var client = new Client('postgres://postgres:postgres@localhost/trigger');

var connect = denodeify(client.connect.bind(client));

connect()
.then(function() { return denodeify(client.query.bind(client)); })
.then(runner)
.catch(function(err) { console.log('error: ', err); process.exit(1); })
.then(function() { console.log('Done'); process.exit(0); });


