<template>
  <!-- eslint-disable -->
  <Page :user="user" selected-tab="budgets">
    <div class="text-center px-6 py-4">
      <div class="flex flex-col mt-8">
        <div class="py-2">
          <div class="align-middle inline-block w-full">
            <BudgetLineItem 
              :amount="b.amount"
              :description="b.name"
              :expensed="b.expensed"
              :currency="b.currency"
              :href="b.href"
              v-for="b in processedBudgets" :key="b.id" />
          </div>
        </div>
        </div>
    </div>
  </Page>
</template>
<script>
import Page from '@/components/Page';
import BudgetLineItem from '@/components/BudgetLineItem';
import { totalBudgetAmount } from '@/features/budgetUtils';
import useAmountFormatter from '@/features/useAmountFormatter';

export default {
  name: 'Budgets',
  components: {
    Page,
    BudgetLineItem
  },
  props: {
    user: {
      type: Object,
      required: true
    },
    budgets: {
      type: Array,
      required: true
    }
  },
  setup(props) {
    const { formatKoboAmount } = useAmountFormatter();
    const processedBudgets = props.budgets
      .map(({ id, href, line_items, name, currency }) => ({
        amount: totalBudgetAmount({ line_items }),
        href,
        id,
        name,
        currency,
        expensed: line_items.reduce((sum, { expensed }) => sum + expensed, 0)
      }));

    const totalAmount = (budget) => formatKoboAmount(totalBudgetAmount(budget), budget.currency);

    return {
      totalAmount,
      processedBudgets
    };
  }
};
</script>
