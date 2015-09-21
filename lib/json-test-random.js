import { generateStrings, generateNumbers } from './util';

const totalRecords = 50000000;
const randomValuesCount = 100;
const randomTagsCount = 10000;

var randomStrings = generateStrings(randomValuesCount);
var randomNumbers = generateNumbers(randomValuesCount);
var randomTags = generateStrings(randomTagsCount);

var query = null;

function insertInitialRecords() {
	var data = {
		"bla bla": "undefined"
	};
	var buffer = [], id = 0;

	function insert(iterationsLeft) {
		if(!iterationsLeft) return;
		
		console.log('adding stuff (%d left)...', iterationsLeft);

		for(var i = 0; i < 10000; i++) {
			// way to get predictable "random" values...

			// scalar values
			data['id']	= ++id;
			data['asd']	= randomStrings[i % randomValuesCount];

			// conditionally 'undefined' values
			if(Math.random() > 0.5) data['num'] = randomNumbers[(10000 - i * iterationsLeft) % randomValuesCount];
			else delete data.num;

			// array values
			data.tags = [];
			for(var ii = 0, r = Math.min(Math.random() * 4, randomTagsCount); ii < r; ii++) {
				data.tags[ii] = randomTags[parseInt(Math.random() * randomTagsCount)];
			}


			buffer[i] = "('" + JSON.stringify(data) + "')";
		}

		var q = query('INSERT INTO jsonb_test_deep(data) VALUES ' + buffer.join(', '));

		return q.then(insert.bind(null, iterationsLeft - 1))
	};

	return insert(totalDistinctRecords / 10000).then(function() { return; });
}

export default function(_query) {
	query = _query;

	var promise = insertInitialRecords();

	return promise;
}
