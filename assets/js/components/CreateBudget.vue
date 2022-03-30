<template>
  <!-- eslint-disable -->
  <div class="px-4 py-3 rounded relative mb-3 bg-white p-4 flex flex-col justify-between leading-normal text-center">
    <h2 class="text-5xl mb-3">Create a budget for {{ state.budget.name }}</h2>
    <form class="w-full max-w-sm">
      <div class="flex items-center border-b border-green-500 py-2">
        <input 
          class="appearance-none bg-transparent border-none w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none" 
          type="text" 
          v-model="state.form.description"
          @keyup.enter="addItem"
          :placeholder="currentPlaceholder">
        <select v-model="state.budget.currency" class="appearance-none bg-transparent border-none w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none">
          <option :key="i" :value="x.value" v-for="(x, i) in currencies">{{ x.label }}</option>
        </select>
        <MoneyInput 
          class="appearance-none bg-transparent border-none w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none" 
          :initial-amount="100"
          :currency-symbol="lineItemCurrencySymbol"
          v-model="state.form.amount" />
        <BudgetButton @click.native="addItem" :disabled="!canAddItem" label="Add" />
      </div>
    </form>
    <div class="flex flex-col mt-8" v-show="state.budget.line_items.length">
      <div class="py-2">
        <div class="align-middle inline-block w-full">
          <table class="w-full">
            <tbody>
              <tr v-for="(lineItem, i) in state.budget.line_items" :key="i">
                <td class="py-3 whitespace-no-wrap text-left border-b border-gray-200 truncate">
                  {{ lineItem.description }}
                </td>
                <td class="py-3 whitespace-no-wrap border-b border-gray-200">
                  {{ amountFormatter(lineItem.amount, state.budget.currency) }}
                </td>
                <td class="py-3 whitespace-no-wrap text-right border-b border-gray-200 text-sm font-medium">
                  <a href="#" @click.stop.prevent="removeLineItem(i)" class="text-gray-600">Remove</a>
                </td>
              </tr>
            </tbody>
            <tfoot>
              <tr>
                <th class="py-3 border-b border-gray-200 bg-gray-50 text-left text-sm font-medium text-gray-500 tracking-wider"></th>
                <th class="py-3 border-b border-gray-200 bg-gray-50 text-sm font-medium text-gray-500 tracking-wider">
                  {{ totalAmount }}
                </th>
                <th class="py-3 border-b border-gray-200 bg-gray-50 text-sm font-medium text-gray-500 tracking-wider"></th>
              </tr>
            </tfoot>
          </table>
        </div>
      </div>
      <BudgetButton @click.native="createBudget" label="Create budget" />
    </div>
  </div>
</template>
<script>
import { reactive, computed } from '@vue/composition-api';
import MoneyInput from '@ukchukx/vue-money-input';
import axios from 'axios';
import { 
  currentBudgetName, 
  currentBudgetStartDate, 
  currentBudgetEndDate, 
  totalBudgetAmount 
} from '@/features/budgetUtils';
import useAmountFormatter from '@/features/useAmountFormatter';
import BudgetButton from '@/components/BudgetButton';

export default {
  name: 'CreateBudget',
  components: {
    BudgetButton,
    MoneyInput
  },
  props: {
    previousBudget: {
      type: Object,
      default: () => null
    }
  },
  setup(props, { emit }) {
    const currencies = [
      { value: 'USD', label: 'US Dollar' },
      { value: 'NGN', label: 'Naira' },
      { value: 'GBP', label: 'British Pound' },
      { value: 'EUR', label: 'Euro' },
      { value: 'SEK', label: 'Swedish Krona' }
    ];
    const currency = 'USD';
    const initialFormValues = { amount: 100, description: '' };
    const { amountFormatter, koboAmountToNaira, currencySymbol } = useAmountFormatter();
    const line_items = (props.previousBudget || { line_items: [] }).line_items
      .filter(({ description }) => description !== 'Unbudgeted')
      .map(({ amount, description }) => ({ amount: koboAmountToNaira(amount), description }));

    const state = reactive({
      budget: {
        name: currentBudgetName(),
        start_date: currentBudgetStartDate(),
        end_date: currentBudgetEndDate(),
        currency,
        line_items
      },
      form: { ...initialFormValues }
    });

    const currentPlaceholder = computed(() => `Budget item #${state.budget.line_items.length + 1}`);
    const trimmedDescription = computed(() => state.form.description.trim());
    const hasDescription = computed(() => !!trimmedDescription.value);
    const hasAmount = computed(() => !!state.form.amount);
    const descriptionUnique = computed(() => 
      state.budget.line_items.every(({ description }) => description !== trimmedDescription.value));
    const isDescriptionValid = computed(() => trimmedDescription.value.toLowerCase() !== 'unbudgeted');
    const canAddItem = computed(() => 
      hasAmount.value && hasDescription.value && descriptionUnique.value && isDescriptionValid.value);
    const totalAmount = computed(() => amountFormatter(totalBudgetAmount(state.budget), state.budget.currency));
    const lineItemCurrencySymbol = computed(() => currencySymbol(state.budget.currency));

    const addItem = () => {
      if (!canAddItem.value) return;

      state.form.description = trimmedDescription.value;
      state.budget.line_items.push(state.form);
      state.form = { ...initialFormValues };
    };
    const removeLineItem = (i) => state.budget.line_items.splice(i, 1);
    const createBudget = () => {
      const params = { ...state.budget };
      params.line_items = params.line_items.map((x) => ({ ...x, amount: x.amount * 100 })); // convert amounts to kobo
      axios.post('/api/budgets', params)
        .then(({ data: { data } }) => {
          emit('budget-created', data);
        });
    };

    return {
      state,
      currentPlaceholder,
      totalAmount,
      addItem,
      canAddItem,
      removeLineItem,
      createBudget,
      amountFormatter,
      lineItemCurrencySymbol,
      currencies
    };
  }
};
</script>
