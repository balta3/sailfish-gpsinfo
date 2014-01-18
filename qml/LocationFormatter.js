.pragma library

var NORTH = 'N';
var SOUTH = 'S';
var EAST = 'E';
var WEST = 'W';

function roundToDecimal(inputNum, numPoints) {
    var multiplier = Math.pow(10, numPoints);
    return Math.round(inputNum * multiplier) / multiplier;
};

function decimalToDMS(location, hemisphere, numSecondPoints) {
    if(location < 0) {
        location *= -1
    }
    var degrees = Math.floor(location);
    var minutesFromRemainder = (location - degrees) * 60;
    var minutes = Math.floor(minutesFromRemainder);
    var secondsFromRemainder = (minutesFromRemainder - minutes) * 60;
    var seconds = roundToDecimal(secondsFromRemainder, numSecondPoints);
    return degrees + '° ' + minutes + "' " + seconds + '" ' + hemisphere;
};

function decimalLatToDMS(location, numSecondPoints) {
    var hemisphere = (location < 0) ? SOUTH : NORTH;
    return decimalToDMS(location, hemisphere, numSecondPoints);
};

function decimalLongToDMS(location, numSecondPoints) {
    var hemisphere = (location < 0) ? WEST : EAST;
    return decimalToDMS(location, hemisphere, numSecondPoints);
};
