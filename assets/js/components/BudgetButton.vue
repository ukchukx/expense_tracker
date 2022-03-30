<template>
  <!-- eslint-disable -->
  <button 
    :disabled="disabled"
    :class="buttonClasses"
    type="button">
    {{ label }}
  </button>
</template>
<script>
import { computed } from '@vue/composition-api';

export default {
  name: 'BudgetButton',
  props: {
    disabled: {
      type: Boolean,
      default: () => false
    },
    label: {
      type: String,
      required: true
    }
  },
  setup(props) {
    const buttonClasses = computed(() => {
      const commonClasses = 'flex-shrink-0 text-sm border-4 py-1 px-2 rounded';
      const activeClasses = props.disabled 
        ? 'bg-grey-500 border-grey-500 text-grey' 
        : 'bg-green-500 border-green-500 text-white';

      return `${commonClasses} ${activeClasses}`;
    });

    return {
      buttonClasses
    };
  }
};
</script>
