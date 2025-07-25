// Generated by CoffeeScript 2.7.0
var echo, wrap;

echo = console.log;

wrap = function(type, attr, ...b) {
  var key, value;
  b = b.join("");
  if (0 === _.size(attr)) {
    return `<${type}>${b}</${type}>`;
  } else {
    attr = ((function() {
      var results;
      results = [];
      for (key in attr) {
        value = attr[key];
        results.push(`${key}=\"${value}\"`);
      }
      return results;
    })()).join(' ');
    return `<${type} ${attr}>${b}</${type}>`;
  }
};

export var table = function(attr, ...b) {
  return wrap('table', attr, ...b);
};

export var thead = function(attr, ...b) {
  return wrap('thead', attr, ...b);
};

export var th = function(attr, ...b) {
  return wrap('th', attr, ...b);
};

export var tr = function(attr, ...b) {
  return wrap('tr', attr, ...b);
};

export var td = function(attr, ...b) {
  return wrap('td', attr, ...b);
};

export var a = function(attr, ...b) {
  return wrap('a', attr, ...b);
};

export var div = function(attr, ...b) {
  return wrap('div', attr, ...b);
};

export var pre = function(attr, ...b) {
  return wrap('pre', attr, ...b);
};

export var p = function(attr, ...b) {
  return wrap('p', attr, ...b);
};

export var h2 = function(attr, ...b) {
  return wrap('h2', attr, ...b);
};

// Exempel 1
console.assert("<table><tr><td>Christer</td><td>Nilsson</td></tr></table>" === table({}, tr({}, td({}, "Christer"), td({}, "Nilsson"))));

// Exempel 2
console.assert('<table><tr><td style="text-align:left" color="red">JanChrister</td><td style="text-align:left">Nilsson</td></tr></table>' === table({}, tr({}, td({
  style: "text-align:left",
  color: "red"
}, "Jan", "Christer"), td({
  style: "text-align:left"
}, "Nilsson"))));

// Resultaten av funktionerna ovan blir alltid en html-sträng

// document.getElementById('tables').innerHTML = tabell

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiaHRtbC5qcyIsInNvdXJjZVJvb3QiOiJcXCIsInNvdXJjZXMiOlsiaHRtbC5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IjtBQUFBLElBQUEsSUFBQSxFQUFBOztBQUFBLElBQUEsR0FBTyxPQUFPLENBQUM7O0FBRWYsSUFBQSxHQUFPLFFBQUEsQ0FBQyxJQUFELEVBQU0sSUFBTixFQUFBLEdBQVcsQ0FBWCxDQUFBO0FBQ1AsTUFBQSxHQUFBLEVBQUE7RUFBQyxDQUFBLEdBQUksQ0FBQyxDQUFDLElBQUYsQ0FBTyxFQUFQO0VBQ0osSUFBRyxDQUFBLEtBQUssQ0FBQyxDQUFDLElBQUYsQ0FBTyxJQUFQLENBQVI7V0FDQyxDQUFBLENBQUEsQ0FBQSxDQUFJLElBQUosQ0FBQSxDQUFBLENBQUEsQ0FBWSxDQUFaLENBQUEsRUFBQSxDQUFBLENBQWtCLElBQWxCLENBQUEsQ0FBQSxFQUREO0dBQUEsTUFBQTtJQUdDLElBQUEsR0FBTzs7QUFBQztNQUFBLEtBQUEsV0FBQTs7cUJBQUEsQ0FBQSxDQUFBLENBQUcsR0FBSCxDQUFBLEdBQUEsQ0FBQSxDQUFZLEtBQVosQ0FBQSxFQUFBO01BQUEsQ0FBQTs7UUFBRCxDQUE2QyxDQUFDLElBQTlDLENBQW1ELEdBQW5EO0FBQ1AsV0FBTyxDQUFBLENBQUEsQ0FBQSxDQUFJLElBQUosRUFBQSxDQUFBLENBQVksSUFBWixDQUFBLENBQUEsQ0FBQSxDQUFvQixDQUFwQixDQUFBLEVBQUEsQ0FBQSxDQUEwQixJQUExQixDQUFBLENBQUEsRUFKUjs7QUFGTTs7QUFRUCxPQUFBLElBQU8sS0FBQSxHQUFRLFFBQUEsQ0FBQyxJQUFELEVBQUEsR0FBTSxDQUFOLENBQUE7U0FBZSxJQUFBLENBQUssT0FBTCxFQUFhLElBQWIsRUFBa0IsR0FBQSxDQUFsQjtBQUFmOztBQUNmLE9BQUEsSUFBTyxLQUFBLEdBQVEsUUFBQSxDQUFDLElBQUQsRUFBQSxHQUFNLENBQU4sQ0FBQTtTQUFlLElBQUEsQ0FBSyxPQUFMLEVBQWEsSUFBYixFQUFrQixHQUFBLENBQWxCO0FBQWY7O0FBQ2YsT0FBQSxJQUFPLEVBQUEsR0FBUSxRQUFBLENBQUMsSUFBRCxFQUFBLEdBQU0sQ0FBTixDQUFBO1NBQWUsSUFBQSxDQUFLLElBQUwsRUFBYSxJQUFiLEVBQWtCLEdBQUEsQ0FBbEI7QUFBZjs7QUFDZixPQUFBLElBQU8sRUFBQSxHQUFRLFFBQUEsQ0FBQyxJQUFELEVBQUEsR0FBTSxDQUFOLENBQUE7U0FBZSxJQUFBLENBQUssSUFBTCxFQUFhLElBQWIsRUFBa0IsR0FBQSxDQUFsQjtBQUFmOztBQUNmLE9BQUEsSUFBTyxFQUFBLEdBQVEsUUFBQSxDQUFDLElBQUQsRUFBQSxHQUFNLENBQU4sQ0FBQTtTQUFlLElBQUEsQ0FBSyxJQUFMLEVBQWEsSUFBYixFQUFrQixHQUFBLENBQWxCO0FBQWY7O0FBQ2YsT0FBQSxJQUFPLENBQUEsR0FBUSxRQUFBLENBQUMsSUFBRCxFQUFBLEdBQU0sQ0FBTixDQUFBO1NBQWUsSUFBQSxDQUFLLEdBQUwsRUFBYSxJQUFiLEVBQWtCLEdBQUEsQ0FBbEI7QUFBZjs7QUFDZixPQUFBLElBQU8sR0FBQSxHQUFRLFFBQUEsQ0FBQyxJQUFELEVBQUEsR0FBTSxDQUFOLENBQUE7U0FBZSxJQUFBLENBQUssS0FBTCxFQUFhLElBQWIsRUFBa0IsR0FBQSxDQUFsQjtBQUFmOztBQUNmLE9BQUEsSUFBTyxHQUFBLEdBQVEsUUFBQSxDQUFDLElBQUQsRUFBQSxHQUFNLENBQU4sQ0FBQTtTQUFlLElBQUEsQ0FBSyxLQUFMLEVBQWEsSUFBYixFQUFrQixHQUFBLENBQWxCO0FBQWY7O0FBQ2YsT0FBQSxJQUFPLENBQUEsR0FBUSxRQUFBLENBQUMsSUFBRCxFQUFBLEdBQU0sQ0FBTixDQUFBO1NBQWUsSUFBQSxDQUFLLEdBQUwsRUFBYSxJQUFiLEVBQWtCLEdBQUEsQ0FBbEI7QUFBZjs7QUFDZixPQUFBLElBQU8sRUFBQSxHQUFRLFFBQUEsQ0FBQyxJQUFELEVBQUEsR0FBTSxDQUFOLENBQUE7U0FBZSxJQUFBLENBQUssSUFBTCxFQUFhLElBQWIsRUFBa0IsR0FBQSxDQUFsQjtBQUFmLEVBbkJmOzs7QUF1QkEsT0FBTyxDQUFDLE1BQVIsQ0FBZSwyREFBQSxLQUErRCxLQUFBLENBQU0sQ0FBQSxDQUFOLEVBQVUsRUFBQSxDQUFHLENBQUEsQ0FBSCxFQUN2RixFQUFBLENBQUcsQ0FBQSxDQUFILEVBQU8sVUFBUCxDQUR1RixFQUV2RixFQUFBLENBQUcsQ0FBQSxDQUFILEVBQU8sU0FBUCxDQUZ1RixDQUFWLENBQTlFLEVBdkJBOzs7QUE2QkEsT0FBTyxDQUFDLE1BQVIsQ0FBZSwwSEFBQSxLQUE4SCxLQUFBLENBQU0sQ0FBQSxDQUFOLEVBQzVJLEVBQUEsQ0FBRyxDQUFBLENBQUgsRUFDQyxFQUFBLENBQUc7RUFBQyxLQUFBLEVBQU8saUJBQVI7RUFBMkIsS0FBQSxFQUFPO0FBQWxDLENBQUgsRUFBNkMsS0FBN0MsRUFBb0QsVUFBcEQsQ0FERCxFQUVDLEVBQUEsQ0FBRztFQUFDLEtBQUEsRUFBTztBQUFSLENBQUgsRUFBK0IsU0FBL0IsQ0FGRCxDQUQ0SSxDQUE3STs7QUE3QkEiLCJzb3VyY2VzQ29udGVudCI6WyJlY2hvID0gY29uc29sZS5sb2dcclxuXHJcbndyYXAgPSAodHlwZSxhdHRyLGIuLi4pIC0+XHJcblx0YiA9IGIuam9pbiBcIlwiXHJcblx0aWYgMCA9PSBfLnNpemUgYXR0clxyXG5cdFx0XCI8I3t0eXBlfT4je2J9PC8je3R5cGV9PlwiXHJcblx0ZWxzZSBcclxuXHRcdGF0dHIgPSAoXCIje2tleX09XFxcIiN7dmFsdWV9XFxcIlwiIGZvciBrZXksdmFsdWUgb2YgYXR0cikuam9pbiAnICdcclxuXHRcdHJldHVybiBcIjwje3R5cGV9ICN7YXR0cn0+I3tifTwvI3t0eXBlfT5cIlxyXG5cclxuZXhwb3J0IHRhYmxlID0gKGF0dHIsYi4uLikgLT4gd3JhcCAndGFibGUnLGF0dHIsYi4uLlxyXG5leHBvcnQgdGhlYWQgPSAoYXR0cixiLi4uKSAtPiB3cmFwICd0aGVhZCcsYXR0cixiLi4uXHJcbmV4cG9ydCB0aCAgICA9IChhdHRyLGIuLi4pIC0+IHdyYXAgJ3RoJywgICBhdHRyLGIuLi5cclxuZXhwb3J0IHRyICAgID0gKGF0dHIsYi4uLikgLT4gd3JhcCAndHInLCAgIGF0dHIsYi4uLlxyXG5leHBvcnQgdGQgICAgPSAoYXR0cixiLi4uKSAtPiB3cmFwICd0ZCcsICAgYXR0cixiLi4uXHJcbmV4cG9ydCBhICAgICA9IChhdHRyLGIuLi4pIC0+IHdyYXAgJ2EnLCAgICBhdHRyLGIuLi5cclxuZXhwb3J0IGRpdiAgID0gKGF0dHIsYi4uLikgLT4gd3JhcCAnZGl2JywgIGF0dHIsYi4uLlxyXG5leHBvcnQgcHJlICAgPSAoYXR0cixiLi4uKSAtPiB3cmFwICdwcmUnLCAgYXR0cixiLi4uXHJcbmV4cG9ydCBwICAgICA9IChhdHRyLGIuLi4pIC0+IHdyYXAgJ3AnLCAgICBhdHRyLGIuLi5cclxuZXhwb3J0IGgyICAgID0gKGF0dHIsYi4uLikgLT4gd3JhcCAnaDInLCAgIGF0dHIsYi4uLlxyXG5cclxuIyBFeGVtcGVsIDFcclxuXHJcbmNvbnNvbGUuYXNzZXJ0IFwiPHRhYmxlPjx0cj48dGQ+Q2hyaXN0ZXI8L3RkPjx0ZD5OaWxzc29uPC90ZD48L3RyPjwvdGFibGU+XCIgPT0gdGFibGUge30sIHRyIHt9LFxyXG5cdHRkIHt9LCBcIkNocmlzdGVyXCJcclxuXHR0ZCB7fSwgXCJOaWxzc29uXCJcclxuXHJcbiMgRXhlbXBlbCAyXHJcblxyXG5jb25zb2xlLmFzc2VydCAnPHRhYmxlPjx0cj48dGQgc3R5bGU9XCJ0ZXh0LWFsaWduOmxlZnRcIiBjb2xvcj1cInJlZFwiPkphbkNocmlzdGVyPC90ZD48dGQgc3R5bGU9XCJ0ZXh0LWFsaWduOmxlZnRcIj5OaWxzc29uPC90ZD48L3RyPjwvdGFibGU+JyA9PSB0YWJsZSB7fSxcclxuXHR0ciB7fSxcclxuXHRcdHRkIHtzdHlsZTogXCJ0ZXh0LWFsaWduOmxlZnRcIiwgY29sb3I6IFwicmVkXCJ9LCBcIkphblwiLCBcIkNocmlzdGVyXCJcclxuXHRcdHRkIHtzdHlsZTogXCJ0ZXh0LWFsaWduOmxlZnRcIn0sIFwiTmlsc3NvblwiXHJcblxyXG4jIFJlc3VsdGF0ZW4gYXYgZnVua3Rpb25lcm5hIG92YW4gYmxpciBhbGx0aWQgZW4gaHRtbC1zdHLDpG5nXHJcblxyXG4jIGRvY3VtZW50LmdldEVsZW1lbnRCeUlkKCd0YWJsZXMnKS5pbm5lckhUTUwgPSB0YWJlbGxcclxuIl19
//# sourceURL=c:\github\2025\013-Berger\html.coffee