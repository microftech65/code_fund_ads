import debounce from 'lodash.debounce'
import { Controller } from 'stimulus'
import StimulusReflex from 'stimulus_reflex'

const dispatchDebouncedInput = debounce(element => {
  const evt = new Event('debounced-input')
  element.dispatchEvent(evt)
}, 300)

document.addEventListener('input', event => {
  dispatchDebouncedInput(event.target)
})

export default class extends Controller {
  connect () {
    StimulusReflex.register(this)
  }
}
