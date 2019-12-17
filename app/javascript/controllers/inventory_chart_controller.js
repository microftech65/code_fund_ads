import { Controller } from 'stimulus'
import * as am4core from '@amcharts/amcharts4/core'
import * as am4charts from '@amcharts/amcharts4/charts'
import am4themes_material from '@amcharts/amcharts4/themes/material'

function dispose (element) {
  if (!element.chart) return
  element.chart.dispose()
  delete element.chart
}

function addAmChartSeries (chart, field, name) {
  const series = chart.series.push(new am4charts.ColumnSeries())
  series.name = name || field
  series.dataFields.valueY = field
  series.dataFields.categoryX = 'date'
  series.sequencedInterpolation = true
  series.stacked = true
  series.columns.template.width = am4core.percent(85)
  series.columns.template.tooltipText =
    '[bold]{name}[/]: {valueY}\n[font-size:14px]{categoryX}'
}

function initAmCharts (element) {
  dispose(element)
  am4core.useTheme(am4themes_material)
  const chart = am4core.create(element, am4charts.XYChart)
  chart.colors.list = [am4core.color('#4fcb4a'), am4core.color('#1181b2')]
  chart.data = JSON.parse(element.dataset.payload)

  const categoryAxis = chart.xAxes.push(new am4charts.CategoryAxis())
  categoryAxis.dataFields.category = 'date'
  categoryAxis.renderer.grid.template.location = 0

  const valueAxis = chart.yAxes.push(new am4charts.ValueAxis())
  valueAxis.renderer.inside = true
  valueAxis.renderer.labels.template.disabled = true
  valueAxis.min = 0

  addAmChartSeries(chart, 'available', 'Available Impressions')
  addAmChartSeries(chart, 'reserved', 'Reserved Impressions')
  chart.legend = new am4charts.Legend()
  element.chart = chart
}

function init (element) {
  if (element.closest('[data-reflex-permanent]')) return
  initAmCharts(element)
}

function rewire () {
  document
    .querySelectorAll('[data-controller="inventory-chart"]')
    .forEach(el => init(el))
}

document.addEventListener('cable-ready:after-morph', rewire)

export default class extends Controller {
  connect () {
    console.log('chart connect')
    init(this.element)
  }

  disconnect () {
    dispose(this.element)
  }
}
