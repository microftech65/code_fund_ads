import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static targets = ['spinner']

  addChartPermanents (ignore) {
    document.querySelectorAll('[data-campaign]').forEach(element => {
      if (element !== ignore)
        element.setAttribute('data-reflex-permanent', true)
    })
  }

  addAllChartPermanents (ignore) {
    document
      .querySelectorAll('[data-campaign]')
      .forEach(element => element.setAttribute('data-reflex-permanent', true))
  }

  removeAllChartPermanents () {
    document
      .querySelectorAll('[data-campaign]')
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
    this.addChartPermanents(element.closest('[data-campaign]'))
  }

  beforeSetCampaignAudience (element) {
    this.addChartPermanents(element.closest('[data-campaign]'))
  }

  beforeSetCampaignRegion (element) {
    this.addChartPermanents(element.closest('[data-campaign]'))
  }

  beforeReflex () {
    this.showActivity()
  }

  afterReflex (element) {
    this.removeAllChartPermanents()
    this.hideActivity()
  }
}
