// ==UserScript==
// @name     MyFitnessPal
// @version  0.1
// @grant    none
// @author   Mike Hodgson
// @namespace  Hodgson
// @include    http://www.myfitnesspal.com/food/diary*
// @include    https://www.myfitnesspal.com/food/diary*
// @require    https://code.jquery.com/jquery-3.3.1.min.js
// @require    https://d3js.org/d3.v4.min.js
// ==/UserScript==

// http://www.cagrimmett.com/til/2016/08/19/d3-pie-chart.html

let carbs, fat, protein;

const $diarytable = $("#diary-table");
const $trtotals = $diarytable.find("tr.total").first();

$trtotals.children().each(function(index, element) {
  switch (index) {
    case 2:
      carbs = parseFloat(element.lastElementChild.innerText);
      break;
    case 3:
      fat = parseFloat(element.lastElementChild.innerText);
      break;
    case 4:
      protein = parseFloat(element.lastElementChild.innerText);
      break;
  }
});

const macroTotal = carbs + fat + protein;

$("#diary-table")
  .find("tr.total")
  .first()
  .next()
  .addBack()
  .find(".macro-percentage")
  .show()
  .css("color", "#777777")
  .append("%")
  .prepend("<br />");

$("#wrap").after('<div id="chart"></div>');
$("#chart").css({
  position: "fixed",
  top: "220px",
  right: "30px"
});

const dataset = [
  { label: "Carbs", count: carbs },
  { label: "Fat", count: fat },
  { label: "Protein", count: protein }
];

const width = 180;
const height = 180;
const radius = Math.min(width, height) / 2;

const color = d3.scaleOrdinal(d3.schemeCategory10);

const svg = d3
  .select("#chart")
  .append("svg")
  .attr("width", width)
  .attr("height", height)
  .append("g")
  .attr("transform", `translate(${width / 2},${height / 2})`);

const arc = d3
  .arc()
  .innerRadius(0)
  .outerRadius(radius - 10);

const pie = d3
  .pie()
  .value(d => d.count)
  .sort(null);

const label = d3
  .arc()
  .outerRadius(radius - 40)
  .innerRadius(radius - 40);

const g = svg
  .selectAll("arc")
  .data(pie(dataset))
  .enter()
  .append("g")
  .attr("class", "arc");

g.append("path")
  .attr("d", arc)
  .attr("fill", d => color(d.data.label));

g.append("text")
  .attr("transform", d => `translate(${label.centroid(d)})`)
  .attr("dy", "0.35em")
  .attr("dx", "-2em")
  .text(
    ({ data: { label }, value }) =>
      `${label.slice(0, 3)} ${Math.round((value / macroTotal) * 100)}%`
  )
  .style("fill", "#fff")
  .style("font-weight", "bold");
