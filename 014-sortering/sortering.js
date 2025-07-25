// Generated by CoffeeScript 2.7.0
var echo, sorteringsOrdning;

sorteringsOrdning = []; // Spara per kolumn

echo = console.log;

document.addEventListener('DOMContentLoaded', function() {
  var i, len, results, th, ths;
  ths = document.querySelectorAll('#minTabell th');
  results = [];
  for (i = 0, len = ths.length; i < len; i++) {
    th = ths[i];
    results.push((function(th) {
      return th.addEventListener('click', function(event) {
        var j, kolumnIndex, len1, rad, rader, results1, stigande, tbody;
        kolumnIndex = parseInt(th.dataset.kolumn);
        tbody = document.querySelector('#minTabell tbody');
        rader = Array.from(tbody.querySelectorAll('tr'));
        stigande = !sorteringsOrdning[kolumnIndex];
        sorteringsOrdning[kolumnIndex] = stigande;
        echo(kolumnIndex);
        echo(sorteringsOrdning);
        rader.sort(function(a, b) {
          var cellA, cellB, numA, numB;
          cellA = a.children[kolumnIndex].textContent.trim();
          cellB = b.children[kolumnIndex].textContent.trim();
          // Försök jämföra som tal, annars som text
          numA = parseFloat(cellA);
          numB = parseFloat(cellB);
          if (!isNaN(numA) && !isNaN(numB)) {
            if (stigande) {
              return numA - numB;
            } else {
              return numB - numA;
            }
          } else {
            if (stigande) {
              return cellA.localeCompare(cellB);
            } else {
              return cellB.localeCompare(cellA);
            }
          }
        });
// Lägg tillbaka raderna i sorterad ordning
        results1 = [];
        for (j = 0, len1 = rader.length; j < len1; j++) {
          rad = rader[j];
          results1.push(tbody.appendChild(rad));
        }
        return results1;
      });
    })(th));
  }
  return results;
});

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoic29ydGVyaW5nLmpzIiwic291cmNlUm9vdCI6IlxcIiwic291cmNlcyI6WyJzb3J0ZXJpbmcuY29mZmVlIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7QUFBQSxJQUFBLElBQUEsRUFBQTs7QUFBQSxpQkFBQSxHQUFvQixHQUFwQjs7QUFDQSxJQUFBLEdBQU8sT0FBTyxDQUFDOztBQUNmLFFBQVEsQ0FBQyxnQkFBVCxDQUEwQixrQkFBMUIsRUFBOEMsUUFBQSxDQUFBLENBQUE7QUFFOUMsTUFBQSxDQUFBLEVBQUEsR0FBQSxFQUFBLE9BQUEsRUFBQSxFQUFBLEVBQUE7RUFBQyxHQUFBLEdBQU0sUUFBUSxDQUFDLGdCQUFULENBQTBCLGVBQTFCO0FBQ047RUFBQSxLQUFBLHFDQUFBOztpQkFDSSxDQUFBLFFBQUEsQ0FBQyxFQUFELENBQUE7YUFDRixFQUFFLENBQUMsZ0JBQUgsQ0FBb0IsT0FBcEIsRUFBNkIsUUFBQSxDQUFDLEtBQUQsQ0FBQTtBQUNoQyxZQUFBLENBQUEsRUFBQSxXQUFBLEVBQUEsSUFBQSxFQUFBLEdBQUEsRUFBQSxLQUFBLEVBQUEsUUFBQSxFQUFBLFFBQUEsRUFBQTtRQUFJLFdBQUEsR0FBYyxRQUFBLENBQVMsRUFBRSxDQUFDLE9BQU8sQ0FBQyxNQUFwQjtRQUNkLEtBQUEsR0FBUSxRQUFRLENBQUMsYUFBVCxDQUF1QixrQkFBdkI7UUFDUixLQUFBLEdBQVEsS0FBSyxDQUFDLElBQU4sQ0FBVyxLQUFLLENBQUMsZ0JBQU4sQ0FBdUIsSUFBdkIsQ0FBWDtRQUVSLFFBQUEsR0FBVyxDQUFDLGlCQUFpQixDQUFDLFdBQUQ7UUFDN0IsaUJBQWlCLENBQUMsV0FBRCxDQUFqQixHQUFpQztRQUNqQyxJQUFBLENBQUssV0FBTDtRQUNBLElBQUEsQ0FBSyxpQkFBTDtRQUVBLEtBQUssQ0FBQyxJQUFOLENBQVcsUUFBQSxDQUFDLENBQUQsRUFBSSxDQUFKLENBQUE7QUFDZixjQUFBLEtBQUEsRUFBQSxLQUFBLEVBQUEsSUFBQSxFQUFBO1VBQUssS0FBQSxHQUFRLENBQUMsQ0FBQyxRQUFRLENBQUMsV0FBRCxDQUFhLENBQUMsV0FBVyxDQUFDLElBQXBDLENBQUE7VUFDUixLQUFBLEdBQVEsQ0FBQyxDQUFDLFFBQVEsQ0FBQyxXQUFELENBQWEsQ0FBQyxXQUFXLENBQUMsSUFBcEMsQ0FBQSxFQURiOztVQUlLLElBQUEsR0FBTyxVQUFBLENBQVcsS0FBWDtVQUNQLElBQUEsR0FBTyxVQUFBLENBQVcsS0FBWDtVQUNQLElBQUcsQ0FBQyxLQUFBLENBQU0sSUFBTixDQUFELElBQWlCLENBQUMsS0FBQSxDQUFNLElBQU4sQ0FBckI7WUFDUSxJQUFHLFFBQUg7cUJBQWlCLElBQUEsR0FBTyxLQUF4QjthQUFBLE1BQUE7cUJBQWtDLElBQUEsR0FBTyxLQUF6QzthQURSO1dBQUEsTUFBQTtZQUdRLElBQUcsUUFBSDtxQkFBaUIsS0FBSyxDQUFDLGFBQU4sQ0FBb0IsS0FBcEIsRUFBakI7YUFBQSxNQUFBO3FCQUFnRCxLQUFLLENBQUMsYUFBTixDQUFvQixLQUFwQixFQUFoRDthQUhSOztRQVBVLENBQVgsRUFUSjs7QUFzQkk7UUFBQSxLQUFBLHlDQUFBOzt3QkFDQyxLQUFLLENBQUMsV0FBTixDQUFrQixHQUFsQjtRQURELENBQUE7O01BdkI0QixDQUE3QjtJQURFLENBQUEsRUFBQztFQURMLENBQUE7O0FBSDZDLENBQTlDIiwic291cmNlc0NvbnRlbnQiOlsic29ydGVyaW5nc09yZG5pbmcgPSBbXVx0IyBTcGFyYSBwZXIga29sdW1uXHJcbmVjaG8gPSBjb25zb2xlLmxvZ1xyXG5kb2N1bWVudC5hZGRFdmVudExpc3RlbmVyICdET01Db250ZW50TG9hZGVkJywgLT5cclxuXHJcblx0dGhzID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvckFsbCAnI21pblRhYmVsbCB0aCdcclxuXHRmb3IgdGggaW4gdGhzXHJcblx0XHRkbyAodGgpIC0+XHJcblx0XHRcdHRoLmFkZEV2ZW50TGlzdGVuZXIgJ2NsaWNrJywgKGV2ZW50KSAtPlxyXG5cdFx0XHRcdGtvbHVtbkluZGV4ID0gcGFyc2VJbnQodGguZGF0YXNldC5rb2x1bW4pXHJcblx0XHRcdFx0dGJvZHkgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yICcjbWluVGFiZWxsIHRib2R5J1xyXG5cdFx0XHRcdHJhZGVyID0gQXJyYXkuZnJvbSB0Ym9keS5xdWVyeVNlbGVjdG9yQWxsICd0cidcclxuXHJcblx0XHRcdFx0c3RpZ2FuZGUgPSAhc29ydGVyaW5nc09yZG5pbmdba29sdW1uSW5kZXhdXHJcblx0XHRcdFx0c29ydGVyaW5nc09yZG5pbmdba29sdW1uSW5kZXhdID0gc3RpZ2FuZGVcclxuXHRcdFx0XHRlY2hvIGtvbHVtbkluZGV4XHJcblx0XHRcdFx0ZWNobyBzb3J0ZXJpbmdzT3JkbmluZ1xyXG5cclxuXHRcdFx0XHRyYWRlci5zb3J0IChhLCBiKSAtPlxyXG5cdFx0XHRcdFx0Y2VsbEEgPSBhLmNoaWxkcmVuW2tvbHVtbkluZGV4XS50ZXh0Q29udGVudC50cmltKClcclxuXHRcdFx0XHRcdGNlbGxCID0gYi5jaGlsZHJlbltrb2x1bW5JbmRleF0udGV4dENvbnRlbnQudHJpbSgpXHJcblxyXG5cdFx0XHRcdFx0IyBGw7Zyc8O2ayBqw6RtZsO2cmEgc29tIHRhbCwgYW5uYXJzIHNvbSB0ZXh0XHJcblx0XHRcdFx0XHRudW1BID0gcGFyc2VGbG9hdCBjZWxsQVxyXG5cdFx0XHRcdFx0bnVtQiA9IHBhcnNlRmxvYXQgY2VsbEJcclxuXHRcdFx0XHRcdGlmICFpc05hTihudW1BKSBhbmQgIWlzTmFOKG51bUIpXHJcblx0XHRcdFx0XHRcdHJldHVybiBpZiBzdGlnYW5kZSB0aGVuIG51bUEgLSBudW1CIGVsc2UgbnVtQiAtIG51bUFcclxuXHRcdFx0XHRcdGVsc2VcclxuXHRcdFx0XHRcdFx0cmV0dXJuIGlmIHN0aWdhbmRlIHRoZW4gY2VsbEEubG9jYWxlQ29tcGFyZSBjZWxsQiBlbHNlIGNlbGxCLmxvY2FsZUNvbXBhcmUgY2VsbEFcclxuXHJcblx0XHRcdFx0IyBMw6RnZyB0aWxsYmFrYSByYWRlcm5hIGkgc29ydGVyYWQgb3JkbmluZ1xyXG5cdFx0XHRcdGZvciByYWQgaW4gcmFkZXJcclxuXHRcdFx0XHRcdHRib2R5LmFwcGVuZENoaWxkIHJhZFxyXG4iXX0=
//# sourceURL=c:\github\2025\014-sortering\sortering.coffee