<template>
  <!-- eslint-disable -->
  <div class="progressbar-wrapper flex mb-4 border-b border-gray-200">
    <div class="w-2/3 whitespace-no-wrap text-xl h-12 text-left truncate">
      <a :href="href">{{ description }}</a>
    </div>
    <div class="w-1/3 whitespace-no-wrap text-xl h-12 text-right">{{ formatKoboAmount(effectiveAmount) }}</div>
    <div class="progressbar" :style="barStyle"></div>
  </div>
</template>
<script>
import { computed } from '@vue/composition-api';
import useAmountFormatter from '@/features/useAmountFormatter';

export default {
  name: 'BudgetLineItem',
  props: {
    description: {
      type: String,
      required: true
    },
    amount: {
      type: Number,
      required: true
    },
    expensed: {
      type: Number,
      required: true
    },
    href: {
      type: String,
      default: () => '#'
    }
  },
  setup(props) {
    const { formatKoboAmount } = useAmountFormatter();
    const red = 'rgba(237, 64, 36, 0.1)';
    const yellow = 'rgba(247, 200, 69, 0.1)';
    const gray = 'rgba(191, 191, 191, 0.1)';

    const barWidth = computed(() => (props.expensed / (props.amount ? props.amount : props.expensed)) * 100);
    const isUnbudgeted = computed(() => props.description === 'Unbudgeted');
    const barColour = computed(() => 
      isUnbudgeted.value ? red : (barWidth.value <= 85 ? gray : (barWidth.value <= 100 ? yellow : red)));
    const barStyle = computed(() => `width: ${barWidth.value}%; background-color: ${barColour.value};`);
    const effectiveAmount = computed(() => isUnbudgeted.value ? props.expensed : props.amount);

    return { formatKoboAmount, effectiveAmount, barStyle };
  }
};
</script>
<style scoped>
.progressbar-wrapper {
  position: relative;
  z-index: 1;
}

.progressbar {
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  z-index: -1;
}
</style>
