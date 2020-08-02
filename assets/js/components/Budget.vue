<template>
  <!-- eslint-disable -->
  <Page v-if="hasBudget" :user="user">
    <CurrentBudget :budget="state.budget" />
  </Page>
  <CreateBudget v-else @budget-created="budgetCreated" />
</template>
<script>
import { computed, reactive } from '@vue/composition-api';
import CreateBudget from '@/components/CreateBudget';
import CurrentBudget from '@/components/CurrentBudget';
import Page from '@/components/Page';

export default {
  name: 'Budget',
  components: {
    CreateBudget,
    CurrentBudget,
    Page
  },
  props: {
    currentBudget: {
      type: Object,
      default: () => null
    },
    user: {
      type: Object,
      required: true
    }
  },
  setup(props) {
    const budget = {
      name: 'August, 2020',
      start_date: '2020-08-02',
      end_date: '2020-08-31',
      line_items: [
        { amount: 1000000, description: 'Budget item #1', expensed: 0 },
        { amount: 1000000, description: 'Budget item #1', expensed: 5000000 },
        { amount: 2000000, description: 'Budget item #2', expensed: 500000 },
        { amount: 3000000, description: 'Budget item #3', expensed: 2800000 }
      ]
    };
    const state = reactive({
      // budget: props.currentBudget
      budget
    });

    const hasBudget = computed(() => state.budget !== null);

    const budgetCreated = (budget) => {
      state.budget = budget;
    };

    return {
      state,
      hasBudget,
      budgetCreated
    };
  }
};
</script>
