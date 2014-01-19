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

function formatDirection(direction) {
    var dirStr;
    if (direction < 11.25) {
        dirStr = "N"
    } else if (direction < 33.75) {
        dirStr = "NNE"
    } else if (direction < 56.25) {
        dirStr = "NE"
    } else if (direction < 78.75) {
        dirStr = "ENE"
    } else if (direction < 101.25) {
        dirStr = "E"
    } else if (direction < 123.75) {
        dirStr = "ESE"
    } else if (direction < 146.25) {
        dirStr = "SE"
    } else if (direction < 168.75) {
        dirStr = "SSE"
    } else if (direction < 191.25) {
        dirStr = "S"
    } else if (direction < 213.75) {
        dirStr = "SSW"
    } else if (direction < 236.25) {
        dirStr = "SW"
    } else if (direction < 258.75) {
        dirStr = "WSW"
    } else if (direction < 281.25) {
        dirStr = "W"
    } else if (direction < 303.75) {
        dirStr = "WNW"
    } else if (direction < 326.25) {
        dirStr = "NW"
    } else if (direction < 348.75) {
        dirStr = "NNW"
    } else if (direction < 360) {
        dirStr = "N"
    } else {
        dirStr = "?"
    }
    return dirStr + " (" + roundToDecimal(direction, 0) + "°)"
}
