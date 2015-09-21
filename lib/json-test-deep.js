import { generateStrings, generateNumbers } from './util';

const totalRecords = 50000000;
const randomValuesCount = 100;
const randomTagsCount = 10000;

var randomStrings = generateStrings(randomValuesCount);
var randomNumbers = generateNumbers(randomValuesCount);
var randomTags = generateStrings(randomTagsCount);

var query = null;

function buildObject(level) {
	var r = Math.floor(Math.random() * 5);
	
	if(!r) return undefined;

	var o = { };
	
	for(var i = 0; i < r; i++) {
		if(Math.random() > 0.7 && level < 5) {
			o['asd'+level+i] = buildObject(level + 1) || 'bla bla';
		} else {
			o['asd'+level+i] = randomStrings[Math.floor(Math.random() * Math.min(randomValuesCount, 5))];
		}
	}

	return o;
}


function insertInitialRecords() {
	var buffer = [], id = 0;

	function insert(iterationsLeft) {
		if(!iterationsLeft) return;
		
		console.log('adding stuff (%d left)...', iterationsLeft);

		for(var i = 0; i < 500; i++) {
			var data = buildObject(0);
			
			if(!data) data = { };
			data.id = ++id;

			buffer[i] = "('" + JSON.stringify(data) + "')";
		}

		var q = query('INSERT INTO "jsonb-test-deep"(data) VALUES ' + buffer.join(', '));

		return q.then(insert.bind(null, iterationsLeft - 1))
	};

	return insert(totalRecords / 500).then(function() { return; });
}

export default function(_query) {
	query = _query;

	var promise = insertInitialRecords();

	return promise;
}
