<template>
  <!-- eslint-disable -->
  <div class="px-4 py-3 rounded relative mb-3 bg-white p-4 flex flex-col justify-between leading-normal text-center">
    <h2 class="text-5xl">{{ budget.name }}</h2>
    <div class="flex flex-col mt-8">
      <div class="py-2">
        <div class="align-middle inline-block w-full">
          <div class="flex mb-4 border-b border-gray-200">
            <div class="w-2/3 whitespace-no-wrap text-xl bg-gray-50 font-medium text-gray-500 h-12 text-left">Item</div>
            <div class="w-1/3 text-right">
              <span class="whitespace-no-wrap text-xl h-12 bg-gray-50 font-medium text-gray-500 text-right md:mr-4">Budgeted</span>
              <span class="whitespace-no-wrap text-xl h-12 bg-gray-50 font-medium text-gray-500 text-right">(Spent)</span>
            </div>
          </div>
          <BudgetLineItem 
            :amount="lineItem.amount"
            :description="lineItem.description"
            :expensed="lineItem.expensed"
            :href="lineItem.href"
            :currency="budget.currency"
            v-for="lineItem in budget.line_items" 
            :key="lineItem.id" />
          <div class="flex mb-4 border-b border-gray-200">
            <div class="w-2/3 whitespace-no-wrap text-xl h-12 text-left"></div>
            <div class="w-1/3 text-right">
              <span class="whitespace-no-wrap text-xl h-12 bg-gray-50 font-medium text-gray-500 text-right md:mr-4">{{ totalAmount }}</span>
              <span class="whitespace-no-wrap text-xl h-12 bg-gray-50 font-medium text-gray-500 text-right">({{ totalExpense }})</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div> 
</template>
<script>
import { computed } from '@vue/composition-api';
import { totalBudgetAmount, totalBudgetExpense } from '@/features/budgetUtils';
import useAmountFormatter from '@/features/useAmountFormatter';
import BudgetLineItem from '@/components/BudgetLineItem';

export default {
  name: 'CurrentBudget',
  components: {
    BudgetLineItem
  },
  props: {
    budget: {
      type: Object,
      required: true
    }
  },
  setup(props) {
    const { formatKoboAmount } = useAmountFormatter();

    const totalAmount = computed(() => formatKoboAmount(totalBudgetAmount(props.budget), props.budget.currency));
    const totalExpense = computed(() => formatKoboAmount(totalBudgetExpense(props.budget), props.budget.currency));

    return { totalAmount, totalExpense };
  }
};
</script>
