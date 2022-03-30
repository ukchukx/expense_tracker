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
        <NairaInput 
          class="appearance-none bg-transparent border-none w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none" 
          :initial-amount="10000"
          ref="amountInput"
          v-model="state.form.amount" />
        <button 
          @click="addItem"
          :disabled="!canAddItem"
          class="flex-shrink-0 bg-green-500 border-green-500 text-sm border-4 text-white py-1 px-2 rounded" 
          type="button">
          Add
        </button>
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
                  {{ amountFormatter(lineItem.amount) }}
                </td>
                <td class="py-3 whitespace-no-wrap text-right border-b border-gray-200 text-sm font-medium">
                  <a href="#" @click.stop.prevent="removeLineItem(i)" class="text-gray-600">Remove</a>
                </td>
              </tr>
            </tbody>
            <tfoot>
              <tr>
                <th class="py-3 border-b border-gray-200 bg-gray-50 text-left text-sm font-medium text-gray-500 uppercase tracking-wider"></th>
                <th class="py-3 border-b border-gray-200 bg-gray-50 text-sm font-medium text-gray-500 uppercase tracking-wider">
                  {{ totalAmount }}
                </th>
                <th class="py-3 border-b border-gray-200 bg-gray-50 text-sm font-medium text-gray-500 uppercase tracking-wider"></th>
              </tr>
            </tfoot>
          </table>
        </div>
      </div>
      <button @click="createBudget" class="bg-green-500 text-white font-bold py-2 px-4 rounded">
        Create budget
      </button>
    </div>
  </div>
</template>
<script>
import { reactive, computed } from '@vue/composition-api';
import NairaInput from 'vue-naira-input';
import axios from 'axios';
import { 
  currentBudgetName, 
  currentBudgetStartDate, 
  currentBudgetEndDate, 
  totalBudgetAmount 
} from '@/features/budgetUtils';
import useAmountFormatter from '@/features/useAmountFormatter';

export default {
  name: 'CreateBudget',
  components: {
    NairaInput
  },
  props: {
    previousBudget: {
      type: Object,
      default: () => null
    }
  },
  setup(props, { refs, emit }) {
    const initialFormValues = { amount: 10000, description: '' };
    const { amountFormatter, koboAmountToNaira } = useAmountFormatter();
    const line_items = (props.previousBudget || { line_items: [] }).line_items
      .filter(({ description }) => description !== 'Unbudgeted')
      .map(({ amount, description }) => ({ amount: koboAmountToNaira(amount), description }));

    const state = reactive({
      budget: {
        name: currentBudgetName(),
        start_date: currentBudgetStartDate(),
        end_date: currentBudgetEndDate(),
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
    const totalAmount = computed(() => amountFormatter(totalBudgetAmount(state.budget)));

    const addItem = () => {
      if (!canAddItem.value) return;

      state.form.description = trimmedDescription.value;
      state.budget.line_items.push(state.form);
      state.form = { ...initialFormValues };
      refs.amountInput.reset();
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
      amountFormatter
    };
  }
};
</script>
