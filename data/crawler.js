/*

This JS script is for grabbing color data from site:
http://www.swisscolors.net/
and save it to a txt file that will be later used in color design

*/

var allDOMs = $('#wrapper > .boxwrapper');


var allColorSchemes = [];

var file = "";


console.log(allDOMs.length);

for(var i = 0; i < allDOMs.length; ++i){

	var colors = [];

	var allColorDOMs =  $(allDOMs[i]).children();

	for(y = 1; y < allColorDOMs.length; y++){
		colors.push($(allColorDOMs[y]).data("color"));
	}
	console.log(colors);

	if(colors!=undefined){
		file+=colors;
		file+="\n";
	}

}

console.log(file);
download(file, "colorSchemes.txt", 'text/plain');

function download(data, filename, type) {
	var file = new Blob([data], {type: type});
	if (window.navigator.msSaveOrOpenBlob) // IE10+
	window.navigator.msSaveOrOpenBlob(file, filename);
	else { // Others
		var a = document.createElement("a"),
		url = URL.createObjectURL(file);
		a.href = url;
		a.download = filename;
		document.body.appendChild(a);
		a.click();
		setTimeout(function() {
			document.body.removeChild(a);
			window.URL.revokeObjectURL(url);
		}, 0);
	}
}
