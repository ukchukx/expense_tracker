<template>
  <!-- eslint-disable -->
  <Page v-if="hasBudget" :user="user" selected-tab="budget">
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
    const state = reactive({
      budget: props.currentBudget
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
