<template>
  <!-- eslint-disable -->
  <div class="progressbar-wrapper flex mb-4 border-b border-gray-200">
    <div class="w-2/3 whitespace-no-wrap text-xl h-12 text-left">{{ lineItem.description }}</div>
    <div class="w-1/3 whitespace-no-wrap text-xl h-12 text-right">{{ formatAsNaira(lineItem.amount) }}</div>
    <div class="progressbar" :style="barStyle"></div>
  </div>
</template>
<script>
import { computed, reactive } from '@vue/composition-api';
import useAmountFormatter from '@/features/useAmountFormatter';

export default {
  name: 'BudgetLineItem',
  props: {
    lineItem: {
      type: Object,
      required: true
    }
  },
  setup(props) {
    const { amountFormatter } = useAmountFormatter();
    const red = '#ED4024';
    const yellow = '#F7C845';
    const gray = '#BFBFBF';

    const barWidth = computed(() => (props.lineItem.expensed / props.lineItem.amount) * 100);
    const barColour = computed(() => barWidth.value <= 50 ? gray : (barWidth.value <= 95 ? yellow : red));
    const barStyle = computed(() => `width: ${barWidth.value}%; background-color: ${barColour.value};`);

    const formatAsNaira = (koboAmount) => amountFormatter((koboAmount / 100).toFixed(2));

    return {
      formatAsNaira,
      barStyle
    };
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