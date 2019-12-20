import ApplicationController from './application_controller'

const chartSelector = '[data-controller="campaign-estimate-chart"]'

export default class extends ApplicationController {
  static targets = ['spinner']

  addChartPermanents (ignore) {
    document.querySelectorAll(chartSelector).forEach(element => {
      if (element !== ignore)
        element.setAttribute('data-reflex-permanent', true)
    })
  }

  addAllChartPermanents (ignore) {
    document
      .querySelectorAll(chartSelector)
      .forEach(element => element.setAttribute('data-reflex-permanent', true))
  }

  removeAllChartPermanents () {
    document
      .querySelectorAll(chartSelector)
      .forEach(element => element.removeAttribute('data-reflex-permanent'))
  }

  showActivity () {
    document.body.classList.add('cursor-wait')
    this.spinnerTarget.hidden = false
    this.spinnerTarget.classList.add('fa-spin')
  }

  hideActivity () {
    document.body.classList.remove('cursor-wait')
    this.spinnerTarget.hidden = true
    this.spinnerTarget.classList.remove('fa-spin')
  }

  // callbacks ....

  beforeSetBudget () {
    this.removeAllChartPermanents()
  }

  beforeSetDates () {
    this.removeAllChartPermanents()
  }

  beforeAddCampaign () {
    this.addAllChartPermanents()
  }

  beforeSetCampaignBudget (element) {
    this.addChartPermanents(
      element.closest('[data-campaign]').querySelector(chartSelector)
    )
  }

  beforeSetCampaignAudience (element) {
    this.addChartPermanents(
      element.closest('[data-campaign]').querySelector(chartSelector)
    )
  }

  beforeSetCampaignRegion (element) {
    this.addChartPermanents(
      element.closest('[data-campaign]').querySelector(chartSelector)
    )
  }

  beforeReflex () {
    this.showActivity()
  }

  afterReflex (element) {
    this.removeAllChartPermanents()
    this.hideActivity()
  }
}
