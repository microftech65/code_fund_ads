import ApplicationController from './application_controller'

export default class extends ApplicationController {
  afterSetCampaignBudget (element) {
    console.log('afterSetCampaignBudget', 'nate')
    const budget = element.value
    const { totalBudget } = element.closest('[data-total-budget]').dataset
    if (Number(budget) !== Number(totalBudget)) element.value = totalBudget
  }
}
