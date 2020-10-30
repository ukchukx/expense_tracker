<template>
  <!-- eslint-disable -->
  <div class="px-4 py-3 rounded relative mb-3 bg-white p-4 flex flex-col justify-between leading-normal text-center">
    <h2 class="text-5xl">{{ item.description }}</h2>
    <form class="w-full max-w-sm">
      <div class="flex items-center border-b border-teal-500 py-2">
        <input 
          class="appearance-none bg-transparent border-none w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none" 
          type="text" 
          v-model="state.form.description"
          @keyup.enter="addExpense"
          :placeholder="placeholder">
        <NairaInput 
          class="appearance-none bg-transparent border-none w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none" 
          :initial-amount="1000"
          ref="amountInput"
          v-model="state.form.amount" />
        <button 
          @click="addExpense"
          :disabled="!canAddExpense"
          class="flex-shrink-0 bg-teal-500 border-teal-500 text-sm border-4 text-white py-1 px-2 rounded" 
          type="button">
          Add expense
        </button>
      </div>
    </form>
    <div class="flex flex-col mt-8" v-show="expenseItems.length">
      <div class="py-2">
        <div class="align-middle inline-block w-full">
          <table class="w-full">
            <tbody>
              <tr v-for="(item, i) in state.expenseItems" :key="item.id">
                <td class="py-3 truncate text-left border-b border-gray-200">
                  {{ item.description }}
                </td>
                <td class="py-3 whitespace-no-wrap text-right border-b border-gray-200">
                  {{ formatKoboAmount(item.amount) }}
                </td>
                <td class="py-3 text-right border-b border-gray-200 text-sm font-medium">
                  <a href="#" @click.stop.prevent="deleteExpense(i)" class="text-gray-600">Delete</a>
                </td>
              </tr>
            </tbody>
            <tfoot>
              <tr>
                <th class="py-3 border-b border-gray-200 bg-gray-50 text-left text-sm font-medium text-gray-500 uppercase tracking-wider"></th>
                <th class="py-3 border-b border-gray-200 bg-gray-50 text-sm font-medium text-gray-500 text-right uppercase tracking-wider">
                  {{ totalAmount }}
                </th>
                <th class="py-3 border-b border-gray-200 bg-gray-50 text-sm font-medium text-gray-500 uppercase tracking-wider"></th>
              </tr>
            </tfoot>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { reactive, computed } from '@vue/composition-api';
import NairaInput from 'vue-naira-input';
import axios from 'axios';
import useAmountFormatter from '@/features/useAmountFormatter';

export default {
  name: 'LineItem',
  components: {
    NairaInput
  },
  props: {
    item: {
      type: Object,
      required: true
    },
    budgetId: {
      type: String,
      required: true
    },
    expenseItems: {
      type: Array,
      required: true
    }
  },
  setup(props, { refs, emit }) {
    const initialFormValues = { 
      amount: 1000, 
      description: props.item.description, 
      budget_id: props.budgetId,
      line_item_id: props.item.id
    };
    const { formatKoboAmount } = useAmountFormatter();

    const state = reactive({
      expenseItems: [...props.expenseItems],
      form: { ...initialFormValues }
    });

    const placeholder = computed(() => props.item.description);
    const trimmedDescription = computed(() => state.form.description.trim());
    const hasDescription = computed(() => !!trimmedDescription.value);
    const hasAmount = computed(() => !!state.form.amount);
    const canAddExpense = computed(() => hasAmount.value && hasDescription.value);
    const totalAmount = computed(() => 
      formatKoboAmount(state.expenseItems.reduce((sum, { amount }) => sum + amount, 0)));

    const addExpense = () => {
      if (!canAddExpense.value) return;

      const params = { ...state.form, amount: state.form.amount * 100 };
      params.description = trimmedDescription.value;
      axios.post('/api/expenses', params)
        .then(({ data: { data } }) => {
          state.expenseItems.push(data);
        });
    };
    const deleteExpense = (index) => {
      if (!confirm('Are you sure?')) return;

      const { id } = state.expenseItems[index];

      axios.delete(`/api/expenses/${id}`)
        .then(() => {
          state.expenseItems.splice(index, 1);
        });
    };

    return {
      state,
      placeholder,
      totalAmount,
      addExpense,
      canAddExpense,
      deleteExpense,
      formatKoboAmount
    };
  }
};
</script>
