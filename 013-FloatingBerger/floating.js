// Generated by CoffeeScript 2.7.0
var echo, range,
  indexOf = [].indexOf;

import {
  Edmonds
} from './blossom.js';

range = _.range;

echo = console.log;

export var Floating = class Floating {
  constructor(players, settings) {
    var edges, edmonds, i, j, k, len, magic, r, ref;
    this.players = players;
    this.settings = settings;
    this.N = this.players.length;
    //@players.sort (a,b) -> a.elo - b.elo
    echo(this.players);
    this.matrix = (function() {
      var k, len, ref, results;
      ref = range(this.N);
      results = [];
      for (k = 0, len = ref.length; k < len; k++) {
        j = ref[k];
        results.push((function() {
          var l, len1, ref1, results1;
          ref1 = range(this.N);
          results1 = [];
          for (l = 0, len1 = ref1.length; l < len1; l++) {
            i = ref1[l];
            results1.push("•");
          }
          return results1;
        }).call(this));
      }
      return results;
    }).call(this);
    echo(this.matrix);
    this.summa = 0;
    this.rounds = [];
    ref = range(this.settings.ROUNDS);
    for (k = 0, len = ref.length; k < len; k++) {
      r = ref[k];
      edges = this.makeEdges();
      echo('edges', edges);
      edmonds = new Edmonds(edges);
      magic = edmonds.maxWeightMatching(edges);
      //echo 'magic',magic
      this.rounds.push(this.updatePlayers(magic, r));
    }
  }

  makeEdges() {
    var a, b, diff, edges, i, j, k, l, len, len1, ref, ref1;
    edges = [];
    ref = range(this.N);
    for (k = 0, len = ref.length; k < len; k++) {
      i = ref[k];
      a = this.players[i];
      ref1 = range(this.N);
      for (l = 0, len1 = ref1.length; l < len1; l++) {
        j = ref1[l];
        if (i === j) {
          this.matrix[i][j] = ' ';
        }
        b = this.players[j];
        diff = Math.abs(a.elo - b.elo);
        if (this.ok(a, b)) {
          edges.push([i, j, 10000 - diff ** 1.01]);
        }
      }
    }
    return edges;
  }

  // sortTables : (tables) -> # Blossom verkar redan ge en bra bordsplacering
  // 	tables.sort (x,y) -> y[2] - x[2]
  // 	table.slice 0,2 for table in tables
  updatePlayers(magic, r) {
    var a, b, i, id, j, k, len, tables;
    tables = [];
    echo('matrix', this.matrix);
    for (k = 0, len = magic.length; k < len; k++) {
      id = magic[k];
      i = id;
      j = magic[id];
      if (i === this.matrix.length || j === this.matrix[0].length) {
        continue;
      }
      this.matrix[i][j] = `${r + this.settings.ONE}`;
      if (i > j) {
        continue;
      }
      echo(i + this.settings.ONE, j + this.settings.ONE, Math.abs(this.players[i].elo - this.players[j].elo));
      this.summa += Math.abs(this.players[i].elo - this.players[j].elo);
      a = this.players[i];
      b = this.players[j];
      a.opp.push(j);
      b.opp.push(i);
      if (a.balans() > b.balans()) {
        a.col += 'b';
        b.col += 'w';
        tables.push([j, i]);
      } else {
        a.col += 'w';
        b.col += 'b';
        tables.push([i, j]);
      }
    }
    //@sortTables tables
    //echo 'updatePlayers',tables
    return tables;
  }

  ok(a, b) {
    var ref;
    if (a.id === b.id) {
      return false;
    }
    if (ref = a.id, indexOf.call(b.opp, ref) >= 0) {
      return false;
    }
    // if not @settings.BALANS and @settings.GAMES % 2 == 0 then return true
    if (this.settings.BALANS === 0) {
      return true;
    }
    return Math.abs(a.balans() + b.balans()) < 2;
  }

};

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZmxvYXRpbmcuanMiLCJzb3VyY2VSb290IjoiXFwiLCJzb3VyY2VzIjpbImZsb2F0aW5nLmNvZmZlZSJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiO0FBQUEsSUFBQSxJQUFBLEVBQUEsS0FBQTtFQUFBOztBQUFBLE9BQUE7RUFBUyxPQUFUO0NBQUEsTUFBQTs7QUFFQSxLQUFBLEdBQVEsQ0FBQyxDQUFDOztBQUNWLElBQUEsR0FBTyxPQUFPLENBQUM7O0FBRWYsT0FBQSxJQUFhLFdBQU4sTUFBQSxTQUFBO0VBQ04sV0FBYyxRQUFBLFVBQUEsQ0FBQTtBQUNmLFFBQUEsS0FBQSxFQUFBLE9BQUEsRUFBQSxDQUFBLEVBQUEsQ0FBQSxFQUFBLENBQUEsRUFBQSxHQUFBLEVBQUEsS0FBQSxFQUFBLENBQUEsRUFBQTtJQURnQixJQUFDLENBQUE7SUFBUyxJQUFDLENBQUE7SUFDekIsSUFBQyxDQUFBLENBQUQsR0FBSyxJQUFDLENBQUEsT0FBTyxDQUFDLE9BQWhCOztJQUVFLElBQUEsQ0FBSyxJQUFDLENBQUEsT0FBTjtJQUNBLElBQUMsQ0FBQSxNQUFEOztBQUFXO0FBQUE7TUFBQSxLQUFBLHFDQUFBOzs7O0FBQUM7QUFBQTtVQUFBLEtBQUEsd0NBQUE7OzBCQUFBO1VBQUEsQ0FBQTs7O01BQUQsQ0FBQTs7O0lBQ1gsSUFBQSxDQUFLLElBQUMsQ0FBQSxNQUFOO0lBQ0EsSUFBQyxDQUFBLEtBQUQsR0FBUztJQUNULElBQUMsQ0FBQSxNQUFELEdBQVU7QUFFVjtJQUFBLEtBQUEscUNBQUE7O01BQ0MsS0FBQSxHQUFRLElBQUMsQ0FBQSxTQUFELENBQUE7TUFDUixJQUFBLENBQUssT0FBTCxFQUFhLEtBQWI7TUFDQSxPQUFBLEdBQVUsSUFBSSxPQUFKLENBQVksS0FBWjtNQUNWLEtBQUEsR0FBUSxPQUFPLENBQUMsaUJBQVIsQ0FBMEIsS0FBMUIsRUFIWDs7TUFLRyxJQUFDLENBQUEsTUFBTSxDQUFDLElBQVIsQ0FBYSxJQUFDLENBQUEsYUFBRCxDQUFlLEtBQWYsRUFB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QUFaLEVBSEQ7T0FBQSxNQUFBO1FBS0MsQ0FBQyxDQUFDLEdBQUYsSUFBUztRQUNULENBQUMsQ0FBQyxHQUFGLElBQVM7UUFDVCxNQUFNLENBQUMsSUFBUCxDQUFZLENBQUMsQ0FBRCxFQUFJLENBQUosQ0FBWixFQVBEOztJQVpELENBRkY7OztXQXlCRTtFQTFCZTs7RUE0QmhCLEVBQUssQ0FBQyxDQUFELEVBQUcsQ0FBSCxDQUFBO0FBQ04sUUFBQTtJQUFFLElBQUcsQ0FBQyxDQUFDLEVBQUYsS0FBUSxDQUFDLENBQUMsRUFBYjtBQUFxQixhQUFPLE1BQTVCOztJQUNBLFVBQUcsQ0FBQyxDQUFDLGlCQUFNLENBQUMsQ0FBQyxLQUFWLFNBQUg7QUFBc0IsYUFBTyxNQUE3QjtLQURGOztJQUdFLElBQUcsSUFBQyxDQUFBLFFBQVEsQ0FBQyxNQUFWLEtBQW9CLENBQXZCO0FBQThCLGFBQU8sS0FBckM7O1dBQ0EsSUFBSSxDQUFDLEdBQUwsQ0FBUyxDQUFDLENBQUMsTUFBRixDQUFBLENBQUEsR0FBYSxDQUFDLENBQUMsTUFBRixDQUFBLENBQXRCLENBQUEsR0FBb0M7RUFMaEM7O0FBN0RDIiwic291cmNlc0NvbnRlbnQiOlsiaW1wb3J0IHsgRWRtb25kcyB9IGZyb20gJy4vYmxvc3NvbS5qcycgIFxyXG5cclxucmFuZ2UgPSBfLnJhbmdlXHJcbmVjaG8gPSBjb25zb2xlLmxvZ1xyXG5cclxuZXhwb3J0IGNsYXNzIEZsb2F0aW5nXHJcblx0Y29uc3RydWN0b3IgOiAoQHBsYXllcnMsIEBzZXR0aW5ncykgLT5cclxuXHRcdEBOID0gQHBsYXllcnMubGVuZ3RoXHJcblx0XHQjQHBsYXllcnMuc29ydCAoYSxiKSAtPiBhLmVsbyAtIGIuZWxvXHJcblx0XHRlY2hvIEBwbGF5ZXJzXHJcblx0XHRAbWF0cml4ID0gKChcIuKAolwiIGZvciBpIGluIHJhbmdlIEBOKSBmb3IgaiBpbiByYW5nZSBATilcclxuXHRcdGVjaG8gQG1hdHJpeFxyXG5cdFx0QHN1bW1hID0gMFxyXG5cdFx0QHJvdW5kcyA9IFtdXHJcblxyXG5cdFx0Zm9yIHIgaW4gcmFuZ2UgQHNldHRpbmdzLlJPVU5EU1xyXG5cdFx0XHRlZGdlcyA9IEBtYWtlRWRnZXMoKVxyXG5cdFx0XHRlY2hvICdlZGdlcycsZWRnZXNcclxuXHRcdFx0ZWRtb25kcyA9IG5ldyBFZG1vbmRzIGVkZ2VzXHJcblx0XHRcdG1hZ2ljID0gZWRtb25kcy5tYXhXZWlnaHRNYXRjaGluZyBlZGdlc1xyXG5cdFx0XHQjZWNobyAnbWFnaWMnLG1hZ2ljXHJcblx0XHRcdEByb3VuZHMucHVzaCBAdXBkYXRlUGxheWVycyBtYWdpYyxyXHJcblxyXG5cdG1ha2VFZGdlcyA6IC0+XHJcblx0XHRlZGdlcyA9IFtdIFxyXG5cdFx0Zm9yIGkgaW4gcmFuZ2UgQE5cclxuXHRcdFx0YSA9IEBwbGF5ZXJzW2ldXHJcblx0XHRcdGZvciBqIGluIHJhbmdlIEBOXHJcblx0XHRcdFx0aWYgaT09aiB0aGVuIEBtYXRyaXhbaV1bal0gPSAnICdcclxuXHRcdFx0XHRiID0gQHBsYXllcnNbal1cclxuXHRcdFx0XHRkaWZmID0gTWF0aC5hYnMgYS5lbG8gLSBiLmVsb1xyXG5cdFx0XHRcdGlmIEBvayBhLGIgdGhlbiBlZGdlcy5wdXNoIFtpLCBqLCAxMDAwMCAtIGRpZmYgKiogMS4wMV1cclxuXHRcdGVkZ2VzXHJcblxyXG5cdCMgc29ydFRhYmxlcyA6ICh0YWJsZXMpIC0+ICMgQmxvc3NvbSB2ZXJrYXIgcmVkYW4gZ2UgZW4gYnJhIGJvcmRzcGxhY2VyaW5nXHJcblx0IyBcdHRhYmxlcy5zb3J0ICh4LHkpIC0+IHlbMl0gLSB4WzJdXHJcblx0IyBcdHRhYmxlLnNsaWNlIDAsMiBmb3IgdGFibGUgaW4gdGFibGVzXHJcblxyXG5cdHVwZGF0ZVBsYXllcnMgOiAobWFnaWMscikgLT4gXHJcblx0XHR0YWJsZXMgPSBbXVxyXG5cdFx0ZWNobyAnbWF0cml4JyxAbWF0cml4XHJcblx0XHRmb3IgaWQgaW4gbWFnaWNcclxuXHRcdFx0aSA9IGlkXHJcblx0XHRcdGogPSBtYWdpY1tpZF1cclxuXHRcdFx0aWYgaSA9PSBAbWF0cml4Lmxlbmd0aCBvciBqID09IEBtYXRyaXhbMF0ubGVuZ3RoIHRoZW4gY29udGludWVcclxuXHRcdFx0QG1hdHJpeFtpXVtqXSA9IFwiI3tyICsgQHNldHRpbmdzLk9ORX1cIlxyXG5cdFx0XHRpZiBpID4gaiB0aGVuIGNvbnRpbnVlXHJcblx0XHRcdGVjaG8gaSArIEBzZXR0aW5ncy5PTkUsIGogKyBAc2V0dGluZ3MuT05FLCBNYXRoLmFicyBAcGxheWVyc1tpXS5lbG8gLSBAcGxheWVyc1tqXS5lbG9cclxuXHRcdFx0QHN1bW1hICs9IE1hdGguYWJzIEBwbGF5ZXJzW2ldLmVsbyAtIEBwbGF5ZXJzW2pdLmVsb1xyXG5cdFx0XHRhID0gQHBsYXllcnNbaV1cclxuXHRcdFx0YiA9IEBwbGF5ZXJzW2pdXHJcblx0XHRcdGEub3BwLnB1c2ggalxyXG5cdFx0XHRiLm9wcC5wdXNoIGlcclxuXHRcdFx0aWYgYS5iYWxhbnMoKSA+IGIuYmFsYW5zKClcclxuXHRcdFx0XHRhLmNvbCArPSAnYidcclxuXHRcdFx0XHRiLmNvbCArPSAndydcclxuXHRcdFx0XHR0YWJsZXMucHVzaCBbaiwgaV1cclxuXHRcdFx0ZWxzZVxyXG5cdFx0XHRcdGEuY29sICs9ICd3J1xyXG5cdFx0XHRcdGIuY29sICs9ICdiJ1xyXG5cdFx0XHRcdHRhYmxlcy5wdXNoIFtpLCBqXVxyXG5cclxuXHRcdCNAc29ydFRhYmxlcyB0YWJsZXNcclxuXHRcdCNlY2hvICd1cGRhdGVQbGF5ZXJzJyx0YWJsZXNcclxuXHRcdHRhYmxlc1xyXG5cclxuXHRvayA6IChhLGIpIC0+IFxyXG5cdFx0aWYgYS5pZCA9PSBiLmlkIHRoZW4gcmV0dXJuIGZhbHNlXHJcblx0XHRpZiBhLmlkIGluIGIub3BwIHRoZW4gcmV0dXJuIGZhbHNlXHJcblx0XHQjIGlmIG5vdCBAc2V0dGluZ3MuQkFMQU5TIGFuZCBAc2V0dGluZ3MuR0FNRVMgJSAyID09IDAgdGhlbiByZXR1cm4gdHJ1ZVxyXG5cdFx0aWYgQHNldHRpbmdzLkJBTEFOUyA9PSAwIHRoZW4gcmV0dXJuIHRydWVcclxuXHRcdE1hdGguYWJzKGEuYmFsYW5zKCkgKyBiLmJhbGFucygpKSA8IDJcclxuIl19
//# sourceURL=c:\github\2025\013-FloatingBerger\floating.coffee