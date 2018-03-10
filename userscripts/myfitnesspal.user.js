// ==UserScript==
// @name     MyFitnessPal
// @version  0.1
// @grant    none
// @author   Mike Hodgson
// @namespace  Hodgson
// @include    http://www.myfitnesspal.com/food/diary*
// @require    https://code.jquery.com/jquery-3.3.1.min.js
// @require    https://d3js.org/d3.v4.min.js
// ==/UserScript==


// TODO redo chart
// http://www.cagrimmett.com/til/2016/08/19/d3-pie-chart.html

var $diarytable = $('#diary-table');
var $trtotals = $diarytable.find('tr.total').first();
var carbs, fat, protein;
$trtotals.children().each(function(index, element){
  switch(index) {
    case 2:
      carbs = element.lastElementChild.innerText;
      break;
    case 3:
      fat = element.lastElementChild.innerText;
      break;
    case 4:
      protein = element.lastElementChild.innerText;
      break;
  }
});

$('#diary-table')
  .find('tr.total').first().next().addBack()
  .find('.macro-percentage').show().css('color','#777777')
  .append('%').prepend('<br />');

$('#wrap').after('<div id="chart"></div>');
$('#chart').css({
  'position':'fixed',
  'top':'220px',
  'right':'30px'
});

var dataset = [
  { label: 'Carbs', count: carbs },
  { label: 'Fat', count: fat },
  { label: 'Protein', count: protein },
];

var width = 180;
var height = 180;
var radius = Math.min(width, height) / 2;

var color = d3.scaleOrdinal(d3.schemeCategory10);
var svg = d3.select('#chart')
.append('svg')
.attr('width', width)
.attr('height', height)
.append('g')
.attr('transform', 'translate(' + (width / 2) +
      ',' + (height / 2) + ')');
var arc = d3.arc()
.innerRadius(0)
.outerRadius(radius);
var pie = d3.pie()
.value(function(d) { return d.count; })
.sort(null);

var label = d3.arc()
    .outerRadius(radius - 40)
    .innerRadius(radius - 40);

var path = svg.selectAll('path')
.data(pie(dataset))
.enter()
.append('path')
.attr('d', arc)
.attr('fill', function(d) {
  return color(d.data.label);
}).append("text")
      .attr("transform", function(d) { return "translate(" + label.centroid(d) + ")"; })
      .attr("dy", "0.35em")
      .text(function(d) { return d.label; });
/*
svg
	.append("text")
      .attr("transform", function(d) { return "translate(" + label.centroid(d) + ")"; })
      .attr("dy", "0.35em")
      .text(function(d) { return d.data.label; });
*/
