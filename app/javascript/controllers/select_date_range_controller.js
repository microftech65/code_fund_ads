// Boostrap requires jQuery
// Our use of it here is simply because its already a dependency
// The verbose use of the `jQuery` variable instead of `$` is intentional so its use is easier to identify
import { Controller } from 'stimulus'
import moment from 'moment'

const selector = '[data-controller="select-date-range"]'

function init (element, options = {}) {
  const defaultOptions = {
    startDate: element.dataset.startDate,
    endDate: element.dataset.endDate,
    locale: {
      format: 'MM/DD/YYYY',
      firstDay: 1
    },
    ranges: {
      'Next 30 Days': [moment(), moment().add(29, 'days')],
      'Next 60 Days': [moment(), moment().add(59, 'days')],
      'Next 90 Days': [moment(), moment().add(89, 'days')],
      'This Month': [moment().startOf('month'), moment().endOf('month')],
      'Next Month': [
        moment()
          .add(1, 'month')
          .startOf('month'),
        moment()
          .add(1, 'month')
          .endOf('month')
      ]
    }
  }

  jQuery(element)
    .daterangepicker(Object.assign(defaultOptions, options))
    .on('apply.daterangepicker', () =>
      element.dispatchEvent(new Event('input', { bubbles: true }))
    )
}

function rewire () {
  document.querySelectorAll(selector).forEach(el => init(el))
}

document.addEventListener('cable-ready:after-morph', rewire)

export default class extends Controller {
  connect () {
    init(this.element)
  }
}
