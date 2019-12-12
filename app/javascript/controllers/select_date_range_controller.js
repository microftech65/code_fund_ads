// Boostrap requires jQuery
// Our use of it here is simply because its already a dependency
// The verbose use of the `jQuery` variable instead of `$` is intentional so its use is easier to identify
import { Controller } from 'stimulus'
import moment from 'moment'

function init (element, options = {}) {
  const defaultOptions = {
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

  jQuery(element).daterangepicker(Object.assign(defaultOptions, options))
}

document.addEventListener('cable-ready:after-morph', () => {
  document
    .querySelectorAll('[data-controller="select-date-range"]')
    .forEach(element => init(element))
})

export default class extends Controller {
  connect () {
    init(this.element)
  }
}
