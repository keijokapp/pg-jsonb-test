export function generateStrings(count, min, max) {
	const characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
	      n_characters = characters.length;
	const c1 = Number.isInteger(min) ? min : 4,
	      c2 = Number.isInteger(max) ? max - min : 5;


	var ret = [];
	for(var i = 0; i < count; i++) {
	    ret[i] = '';
	    for(var ii = 0, r = Math.random() * c1 + c2; ii < r; ii++) {
	        ret[i] += characters.charAt(Math.floor(Math.random() * n_characters));
		}
	}
	return ret;
}

export function generateNumbers(count) {
	var ret = [];
	for(var i = 0; i < count; i++) {
		ret[i] = parseInt(Math.random() * 99999999999);
	}
	return ret;
}

