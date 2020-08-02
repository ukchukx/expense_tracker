<template>
  <!-- eslint-disable -->
  <div class="fixed bottom-0 inset-x-0 bg-white h-24 w-full">
    <div class="block w-full">
      <div class="container mx-auto">
        <div class="flex items-stretch">
          <div class="flex mx-auto">
            <a href="/" :class="state.budgetClasses">
              <i class="far fa-chart-bar fa-2x h-6 w-6 fill-current block mx-auto"></i>
              <span class="text-sm md:text-md">Budget</span>
            </a>
          </div>
          <div class="flex mx-auto">
            <a href="/budgets" :class="state.budgetsClasses">
              <i class="far fa-list-alt fa-2x h-6 w-6 fill-current block mx-auto"></i>
              <span class="text-sm md:text-md">Budgets</span>
            </a>
          </div>
          <div class="flex mx-auto">
            <a href="/account" :class="state.accountClasses">
              <i class="far fa-user fa-2x h-6 w-6 fill-current block mx-auto"></i>
              <span class="text-sm md:text-md">Account</span>
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { reactive, computed } from '@vue/composition-api';

export default {
  name: 'BottomBar',
  props: {
    selectedTab: {
      type: String,
      default: () => 'budget'
    }
  },
  setup(props) {
    const commonClasses = 'no-underline inline-block text-center py-4 border-b';
    let defaultClasses = 'opacity-50 text-gray-600 md:opacity-100 border-transparent';
    defaultClasses = `md:hover:border-gray-600 ${defaultClasses} ${commonClasses}`;
    const activeClasses = `text-teal-600 border-teal-600 ${commonClasses}`;

    const budgetSelected = computed(() => props.selectedTab === 'budget');
    const budgetsSelected = computed(() => props.selectedTab === 'budgets');
    const accountSelected = computed(() => props.selectedTab === 'account');

    const state = reactive({
      budgetClasses: computed(() => budgetSelected.value ? activeClasses : defaultClasses),
      budgetsClasses: computed(() => budgetsSelected.value ? activeClasses : defaultClasses),
      accountClasses: computed(() => accountSelected.value ? activeClasses : defaultClasses)
    });

    return {
      state
    };
  }
};
</script>
