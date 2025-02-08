// Generated by CoffeeScript 2.7.0
var echo, fetch, formatPGN, getHeader, parsePGN, pretty, removeEval, removeParenthesis, splitMoves, tabell,
  indexOf = [].indexOf;

echo = console.log;

formatPGN = function() {
  var ctrlA, ctrlB, ctrlC, input;
  ctrlA = document.getElementById("pgn-input");
  ctrlB = document.getElementById("knapp");
  ctrlC = document.getElementById("output");
  ctrlA.hidden = true;
  ctrlB.hidden = true;
  input = ctrlA.value;
  return ctrlC.innerHTML = parsePGN(input);
};

pretty = function(raw) {
  var arr, move;
  if (indexOf.call(raw, "{") < 0) {
    return [raw.trim(), '', ''];
  }
  arr = raw.split(' ');
  move = arr[0];
  if ("Inaccuracy." === arr[3]) {
    return [move, ' • ', arr[4]];
  }
  if ("Mistake." === arr[3]) {
    return [move, ' •• ', arr[4]];
  }
  if ("Blunder." === arr[3]) {
    return [move, ' ••• ', arr[4]];
  }
  if ("Checkmate" === arr[3]) {
    return [move, ' ••• ', arr[7]];
  }
  if ("checkmate" === arr[5]) {
    return [move, ' ••• ', arr[7]];
  }
  return [move, '', ''];
};

// echo ["d5",""], pretty "d5  "
// pretty "Bh5  { Inaccuracy. Bxf3 was best. }  " => ["Bh5","• (Bxf3)"]
fetch = function(pgn, move, offset, start, stopp) {
  var a, p, q, result;
  a = offset + move.toString().length;
  p = pgn.indexOf(start);
  q = pgn.indexOf(stopp);
  if (p === -1) {
    return ['', '', ''];
  }
  if (q === -1) {
    q = pgn.length;
  }
  result = pretty(pgn.substring(p + a, q));
  echo(result);
  return result;
};

splitMoves = function(pgn) {
  var arr, b, move, w;
  arr = [];
  move = 1;
  while (true) {
    w = fetch(pgn, move, 2, move + '.', move + '...');
    b = fetch(pgn, move, 4, move + '...', (move + 1) + '.');
    arr.push(w);
    if (b.join('').length === 0) {
      break;
    }
    arr.push(b);
    move++;
  }
  return arr;
};

removeParenthesis = function(pgn) {
  var ch, j, len, level, result;
  result = "";
  level = 0;
  for (j = 0, len = pgn.length; j < len; j++) {
    ch = pgn[j];
    if (ch === '(') {
      level++;
    } else if (ch === ')') {
      level--;
    } else if (level === 0) {
      result += ch;
    }
  }
  return result;
};

removeEval = function(pgn) {
  var ch, j, len, level, result;
  result = "";
  level = 0;
  for (j = 0, len = pgn.length; j < len; j++) {
    ch = pgn[j];
    if (ch === '[') {
      level = level + 1;
    } else if (ch === ']') {
      level = level - 1;
    } else if (level === 0) {
      result += ch;
    }
  }
  return result;
};

tabell = function(arr, start, stopp) {
  var a, b, c, d, e, f, i, n, s;
  s = "";
  n = arr.length; // antal ply
  echo(n, start, stopp);
  if (start >= n) {
    return '';
  }
  //arr = arr.slice start,stopp
  i = start / 2;
  while (i < stopp / 2) { // moves
    [a, b, c] = ['', '', ''];
    [d, e, f] = ['', '', ''];
    if (2 * i < n) {
      [c, b, a] = arr[2 * i];
    }
    if (2 * i + 1 < n) {
      [d, e, f] = arr[2 * i + 1];
    }
    s += `<tr><td>${a}</td><td>${b}</td><td>${c}</td><td><strong>${1 + i}</strong></td><td>${d}</td><td>${e}</td><td>${f}</td></tr>`;
    i++;
  }
  return '<table class="inner-table">' + s + '</table>';
};

getHeader = function(pgn) {
  var arr, attrs, i, j, line, name, p, ref, result, value;
  arr = pgn.split('\n');
  attrs = {};
  result = "";
  attrs.Event = "";
  attrs.Date = "";
  attrs.Site = "";
  attrs.TimeControl = "";
  attrs.FEN = "";
  attrs.WhiteElo = "";
  attrs.White = "";
  attrs.BlackElo = "";
  attrs.Black = "";
  attrs.Result = "";
  for (i = j = 0, ref = arr.length; (0 <= ref ? j < ref : j > ref); i = 0 <= ref ? ++j : --j) {
    line = arr[i].trim();
    if (line === '') {
      break;
    }
    p = line.indexOf(' ');
    name = line.substring(1, p);
    value = line.substring(p + 2, line.length - 2);
    attrs[name] = value;
  }
  return `${attrs.Event} ${attrs.Date}<br>Site: ${attrs.Site}<br> FEN: ${attrs.FEN}<br> White: ${attrs.WhiteElo} ${attrs.White}<br>Black: ${attrs.BlackElo} ${attrs.Black}<br>${attrs.Result}`;
};

parsePGN = function(pgn) {
  var a, arr, b, header;
  header = getHeader(pgn);
  echo(header);
  pgn = removeParenthesis(pgn);
  pgn = removeEval(pgn);
  pgn = pgn.replaceAll('{  }', '');
  pgn = pgn.replaceAll('??', '');
  pgn = pgn.replaceAll('?!', '');
  pgn = pgn.replaceAll('?', '');
  pgn = pgn.replaceAll('0-1', '');
  pgn = pgn.replaceAll('1/2-1/2', '');
  pgn = pgn.replaceAll('1-0', '');
  pgn = pgn.replaceAll('*', '');
  arr = splitMoves(pgn);
  echo('arr', arr);
  a = tabell(arr, 0, 80);
  b = tabell(arr, 80, 160);
  return `<table class=\"outer-table\"><tr><td style=\"text-align:left\">${header}</td></tr><tr><td>${a}</td><td style=\"width:20px\"></td><td>${b}</td></tr></table>`;
};

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoic2tldGNoLmpzIiwic291cmNlUm9vdCI6Ii4uXFwiLCJzb3VyY2VzIjpbImNvZmZlZVxcc2tldGNoLmNvZmZlZSJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiO0FBQUEsSUFBQSxJQUFBLEVBQUEsS0FBQSxFQUFBLFNBQUEsRUFBQSxTQUFBLEVBQUEsUUFBQSxFQUFBLE1BQUEsRUFBQSxVQUFBLEVBQUEsaUJBQUEsRUFBQSxVQUFBLEVBQUEsTUFBQTtFQUFBOztBQUFBLElBQUEsR0FBTyxPQUFPLENBQUM7O0FBRWYsU0FBQSxHQUFZLFFBQUEsQ0FBQSxDQUFBO0FBQ1osTUFBQSxLQUFBLEVBQUEsS0FBQSxFQUFBLEtBQUEsRUFBQTtFQUFDLEtBQUEsR0FBUSxRQUFRLENBQUMsY0FBVCxDQUF3QixXQUF4QjtFQUNSLEtBQUEsR0FBUSxRQUFRLENBQUMsY0FBVCxDQUF3QixPQUF4QjtFQUNSLEtBQUEsR0FBUSxRQUFRLENBQUMsY0FBVCxDQUF3QixRQUF4QjtFQUNSLEtBQUssQ0FBQyxNQUFOLEdBQWU7RUFDZixLQUFLLENBQUMsTUFBTixHQUFlO0VBQ2YsS0FBQSxHQUFRLEtBQUssQ0FBQztTQUNkLEtBQUssQ0FBQyxTQUFOLEdBQWtCLFFBQUEsQ0FBUyxLQUFUO0FBUFA7O0FBU1osTUFBQSxHQUFTLFFBQUEsQ0FBQyxHQUFELENBQUE7QUFDVCxNQUFBLEdBQUEsRUFBQTtFQUFDLGlCQUFjLEtBQVgsUUFBSDtBQUF1QixXQUFPLENBQUMsR0FBRyxDQUFDLElBQUosQ0FBQSxDQUFELEVBQVksRUFBWixFQUFlLEVBQWYsRUFBOUI7O0VBQ0EsR0FBQSxHQUFNLEdBQUcsQ0FBQyxLQUFKLENBQVUsR0FBVjtFQUNOLElBQUEsR0FBTyxHQUFHLENBQUMsQ0FBRDtFQUNWLElBQUcsYUFBQSxLQUFpQixHQUFHLENBQUMsQ0FBRCxDQUF2QjtBQUFnQyxXQUFPLENBQUMsSUFBRCxFQUFPLEtBQVAsRUFBZ0IsR0FBRyxDQUFDLENBQUQsQ0FBbkIsRUFBdkM7O0VBQ0EsSUFBRyxV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LEdBQUEsR0FBTSxHQUFHLENBQUMsVUFBSixDQUFlLElBQWYsRUFBb0IsRUFBcEI7RUFDTixHQUFBLEdBQU0sR0FBRyxDQUFDLFVBQUosQ0FBZSxHQUFmLEVBQW1CLEVBQW5CO0VBQ04sR0FBQSxHQUFNLEdBQUcsQ0FBQyxVQUFKLENBQWUsS0FBZixFQUFxQixFQUFyQjtFQUNOLEdBQUEsR0FBTSxHQUFHLENBQUMsVUFBSixDQUFlLFNBQWYsRUFBeUIsRUFBekI7RUFDTixHQUFBLEdBQU0sR0FBRyxDQUFDLFVBQUosQ0FBZSxLQUFmLEVBQXFCLEVBQXJCO0VBQ04sR0FBQSxHQUFNLEdBQUcsQ0FBQyxVQUFKLENBQWUsR0FBZixFQUFtQixFQUFuQjtFQUNOLEdBQUEsR0FBTSxVQUFBLENBQVcsR0FBWDtFQUNOLElBQUEsQ0FBSyxLQUFMLEVBQVcsR0FBWDtFQUVBLENBQUEsR0FBSSxNQUFBLENBQU8sR0FBUCxFQUFZLENBQVosRUFBYyxFQUFkO0VBQ0osQ0FBQSxHQUFJLE1BQUEsQ0FBTyxHQUFQLEVBQVksRUFBWixFQUFlLEdBQWY7U0FFSixDQUFBLCtEQUFBLENBQUEsQ0FBa0UsTUFBbEUsQ0FBQSxrQkFBQSxDQUFBLENBQTZGLENBQTdGLENBQUEsdUNBQUEsQ0FBQSxDQUF3SSxDQUF4SSxDQUFBLGtCQUFBO0FBbkJVIiwic291cmNlc0NvbnRlbnQiOlsiZWNobyA9IGNvbnNvbGUubG9nXHJcblxyXG5mb3JtYXRQR04gPSAtPlxyXG5cdGN0cmxBID0gZG9jdW1lbnQuZ2V0RWxlbWVudEJ5SWQgXCJwZ24taW5wdXRcIlxyXG5cdGN0cmxCID0gZG9jdW1lbnQuZ2V0RWxlbWVudEJ5SWQgXCJrbmFwcFwiXHJcblx0Y3RybEMgPSBkb2N1bWVudC5nZXRFbGVtZW50QnlJZCBcIm91dHB1dFwiXHJcblx0Y3RybEEuaGlkZGVuID0gdHJ1ZVxyXG5cdGN0cmxCLmhpZGRlbiA9IHRydWVcclxuXHRpbnB1dCA9IGN0cmxBLnZhbHVlXHJcblx0Y3RybEMuaW5uZXJIVE1MID0gcGFyc2VQR04gaW5wdXQgXHJcblxyXG5wcmV0dHkgPSAocmF3KSAtPlxyXG5cdGlmIFwie1wiIG5vdCBpbiByYXcgdGhlbiByZXR1cm4gW3Jhdy50cmltKCksJycsJyddXHJcblx0YXJyID0gcmF3LnNwbGl0ICcgJ1xyXG5cdG1vdmUgPSBhcnJbMF1cclxuXHRpZiBcIkluYWNjdXJhY3kuXCIgPT0gYXJyWzNdIHRoZW4gcmV0dXJuIFttb3ZlLCAnIOKAoiAnLCAgIGFycls0XV1cclxuXHRpZiBcIk1pc3Rha2UuXCIgICAgPT0gYXJyWzNdIHRoZW4gcmV0dXJuIFttb3ZlLCAnIOKAouKAoiAnLCAgYXJyWzRdXVxyXG5cdGlmIFwiQmx1bmRlci5cIiAgICA9PSBhcnJbM10gdGhlbiByZXR1cm4gW21vdmUsICcg4oCi4oCi4oCiICcsIGFycls0XV1cclxuXHRpZiBcIkNoZWNrbWF0ZVwiICAgPT0gYXJyWzNdIHRoZW4gcmV0dXJuIFttb3ZlLCAnIOKAouKAouKAoiAnLCBhcnJbN11dXHJcblx0aWYgXCJjaGVja21hdGVcIiAgID09IGFycls1XSB0aGVuIHJldHVybiBbbW92ZSwgJyDigKLigKLigKIgJywgYXJyWzddXVxyXG5cdFttb3ZlLCcnLCcnXVxyXG4jIGVjaG8gW1wiZDVcIixcIlwiXSwgcHJldHR5IFwiZDUgIFwiXHJcbiMgcHJldHR5IFwiQmg1ICB7IEluYWNjdXJhY3kuIEJ4ZjMgd2FzIGJlc3QuIH0gIFwiID0+IFtcIkJoNVwiLFwi4oCiIChCeGYzKVwiXVxyXG5cclxuZmV0Y2ggPSAocGduLCBtb3ZlLCBvZmZzZXQsIHN0YXJ0LCBzdG9wcCkgLT5cclxuXHRhID0gb2Zmc2V0ICsgbW92ZS50b1N0cmluZygpLmxlbmd0aFxyXG5cdHAgPSBwZ24uaW5kZXhPZiBzdGFydFxyXG5cdHEgPSBwZ24uaW5kZXhPZiBzdG9wcFxyXG5cdGlmIHAgPT0gLTEgdGhlbiByZXR1cm4gWycnLCcnLCcnXVxyXG5cdGlmIHEgPT0gLTEgdGhlbiBxID0gcGduLmxlbmd0aFxyXG5cdHJlc3VsdCA9IHByZXR0eSBwZ24uc3Vic3RyaW5nIHArYSxxXHJcblx0ZWNobyByZXN1bHRcclxuXHRyZXN1bHRcclxuXHJcbnNwbGl0TW92ZXMgPSAocGduKSAtPlxyXG5cdGFyciA9IFtdXHJcblx0bW92ZSA9IDEgXHJcblx0d2hpbGUgdHJ1ZVxyXG5cdFx0dyA9IGZldGNoIHBnbiwgbW92ZSwgMiwgbW92ZSArICcuJywgbW92ZSArICcuLi4nXHJcblx0XHRiID0gZmV0Y2ggcGduLCBtb3ZlLCA0LCBtb3ZlICsgJy4uLicsIChtb3ZlKzEpICsgJy4nXHJcblx0XHRhcnIucHVzaCB3XHJcblx0XHRpZiBiLmpvaW4oJycpLmxlbmd0aCA9PSAwIHRoZW4gYnJlYWtcclxuXHRcdGFyci5wdXNoIGJcclxuXHRcdG1vdmUrK1xyXG5cdGFyclxyXG5cclxucmVtb3ZlUGFyZW50aGVzaXMgPSAocGduKSAtPlxyXG5cdHJlc3VsdCA9IFwiXCJcclxuXHRsZXZlbCA9IDBcclxuXHRmb3IgY2ggaW4gcGduXHJcblx0XHRpZiBjaCA9PSAnKCcgdGhlbiBsZXZlbCsrXHJcblx0XHRlbHNlIGlmIGNoID09ICcpJyB0aGVuIGxldmVsLS1cclxuXHRcdGVsc2UgaWYgbGV2ZWwgPT0gMCB0aGVuIHJlc3VsdCArPSBjaFxyXG5cdHJlc3VsdFxyXG5cclxucmVtb3ZlRXZhbCA9IChwZ24pIC0+XHJcblx0cmVzdWx0ID0gXCJcIlxyXG5cdGxldmVsID0gMFxyXG5cdGZvciBjaCBpbiBwZ25cclxuXHRcdGlmIGNoPT0nWycgdGhlbiBsZXZlbCA9IGxldmVsICsgMVxyXG5cdFx0ZWxzZSBpZiBjaD09J10nIHRoZW4gbGV2ZWwgPSBsZXZlbCAtIDFcclxuXHRcdGVsc2UgaWYgbGV2ZWwgPT0gMCB0aGVuIHJlc3VsdCArPSBjaFxyXG5cdHJlc3VsdFxyXG5cclxudGFiZWxsID0gKGFycixzdGFydCxzdG9wcCkgLT5cclxuXHRzID0gXCJcIlxyXG5cdG4gPSBhcnIubGVuZ3RoICMgYW50YWwgcGx5XHJcblx0ZWNobyBuLHN0YXJ0LHN0b3BwXHJcblx0aWYgc3RhcnQgPj0gbiB0aGVuIHJldHVybiAnJ1xyXG5cdCNhcnIgPSBhcnIuc2xpY2Ugc3RhcnQsc3RvcHBcclxuXHRpID0gc3RhcnQvMlxyXG5cdHdoaWxlIGkgPCBzdG9wcC8yICMgbW92ZXNcclxuXHRcdFthLGIsY10gPSBbJycsJycsJyddXHJcblx0XHRbZCxlLGZdID0gWycnLCcnLCcnXVxyXG5cdFx0aWYgMippIDwgbiB0aGVuIFtjLGIsYV0gPSBhcnJbMippXVxyXG5cdFx0aWYgMippKzEgPCBuIHRoZW4gW2QsZSxmXSA9IGFyclsyKmkrMV1cclxuXHRcdHMgKz0gXCI8dHI+PHRkPiN7YX08L3RkPjx0ZD4je2J9PC90ZD48dGQ+I3tjfTwvdGQ+PHRkPjxzdHJvbmc+I3sxK2l9PC9zdHJvbmc+PC90ZD48dGQ+I3tkfTwvdGQ+PHRkPiN7ZX08L3RkPjx0ZD4je2Z9PC90ZD48L3RyPlwiXHJcblx0XHRpKysgXHJcblx0Jzx0YWJsZSBjbGFzcz1cImlubmVyLXRhYmxlXCI+JyArIHMgKyAnPC90YWJsZT4nXHJcblxyXG5nZXRIZWFkZXIgPSAocGduKSAtPlxyXG5cdGFyciA9IHBnbi5zcGxpdCAnXFxuJ1xyXG5cdGF0dHJzID0ge31cclxuXHRyZXN1bHQgPSBcIlwiXHJcblx0YXR0cnMuRXZlbnQgPSBcIlwiXHJcblx0YXR0cnMuRGF0ZSA9IFwiXCJcclxuXHRhdHRycy5TaXRlID0gXCJcIlxyXG5cdGF0dHJzLlRpbWVDb250cm9sID0gXCJcIlxyXG5cdGF0dHJzLkZFTiA9IFwiXCJcclxuXHRhdHRycy5XaGl0ZUVsbyA9IFwiXCJcclxuXHRhdHRycy5XaGl0ZSA9IFwiXCJcclxuXHRhdHRycy5CbGFja0VsbyA9IFwiXCJcclxuXHRhdHRycy5CbGFjayA9IFwiXCJcclxuXHRhdHRycy5SZXN1bHQgPSBcIlwiXHJcblx0Zm9yIGkgaW4gWzAuLi5hcnIubGVuZ3RoXVxyXG5cdFx0bGluZSA9IGFycltpXS50cmltKClcclxuXHRcdGlmIGxpbmUgPT0gJycgdGhlbiBicmVha1xyXG5cdFx0cCA9IGxpbmUuaW5kZXhPZiAnICdcclxuXHRcdG5hbWUgPSBsaW5lLnN1YnN0cmluZyAxLHBcclxuXHRcdHZhbHVlID0gbGluZS5zdWJzdHJpbmcgcCsyLGxpbmUubGVuZ3RoLTJcclxuXHRcdGF0dHJzW25hbWVdID0gdmFsdWVcclxuXHRcIiN7YXR0cnMuRXZlbnR9ICN7YXR0cnMuRGF0ZX08YnI+U2l0ZTogI3thdHRycy5TaXRlfTxicj4gRkVOOiAje2F0dHJzLkZFTn08YnI+IFdoaXRlOiAje2F0dHJzLldoaXRlRWxvfSAje2F0dHJzLldoaXRlfTxicj5CbGFjazogI3thdHRycy5CbGFja0Vsb30gI3thdHRycy5CbGFja308YnI+I3thdHRycy5SZXN1bHR9XCJcclxuXHJcbnBhcnNlUEdOID0gKHBnbikgLT4gXHJcblx0aGVhZGVyID0gZ2V0SGVhZGVyIHBnblxyXG5cdGVjaG8gaGVhZGVyXHJcblx0cGduID0gcmVtb3ZlUGFyZW50aGVzaXMocGduKVxyXG5cdHBnbiA9IHJlbW92ZUV2YWwgcGduXHJcblx0cGduID0gcGduLnJlcGxhY2VBbGwgJ3sgIH0nLCcnXHJcblx0cGduID0gcGduLnJlcGxhY2VBbGwgJz8/JywnJ1xyXG5cdHBnbiA9IHBnbi5yZXBsYWNlQWxsICc/IScsJydcclxuXHRwZ24gPSBwZ24ucmVwbGFjZUFsbCAnPycsJydcclxuXHRwZ24gPSBwZ24ucmVwbGFjZUFsbCAnMC0xJywnJ1xyXG5cdHBnbiA9IHBnbi5yZXBsYWNlQWxsICcxLzItMS8yJywnJ1xyXG5cdHBnbiA9IHBnbi5yZXBsYWNlQWxsICcxLTAnLCcnXHJcblx0cGduID0gcGduLnJlcGxhY2VBbGwgJyonLCcnXHJcblx0YXJyID0gc3BsaXRNb3ZlcyBwZ25cclxuXHRlY2hvICdhcnInLGFyclxyXG5cclxuXHRhID0gdGFiZWxsIGFyciwgMCw4MFxyXG5cdGIgPSB0YWJlbGwgYXJyLCA4MCwxNjBcclxuXHRcclxuXHRcIjx0YWJsZSBjbGFzcz1cXFwib3V0ZXItdGFibGVcXFwiPjx0cj48dGQgc3R5bGU9XFxcInRleHQtYWxpZ246bGVmdFxcXCI+I3toZWFkZXJ9PC90ZD48L3RyPjx0cj48dGQ+I3thfTwvdGQ+PHRkIHN0eWxlPVxcXCJ3aWR0aDoyMHB4XFxcIj48L3RkPjx0ZD4je2J9PC90ZD48L3RyPjwvdGFibGU+XCJcclxuIl19
//# sourceURL=c:\github\2025\003-PrettyPGN\coffee\sketch.coffee