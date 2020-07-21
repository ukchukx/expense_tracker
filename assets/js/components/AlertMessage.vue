<template>
  <!-- eslint-disable -->
  <div v-show="state.shown" :class="state.divClasses" role="alert">
    <strong class="font-bold">{{ emphasis }}</strong>
    <span class="block inline">{{ text }}</span>
    <span @click="onClose" class="absolute top-0 bottom-0 right-0 px-4 py-3">
      <svg :class="state.svgClasses" role="button" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><title>Close</title><path d="M14.348 14.849a1.2 1.2 0 0 1-1.697 0L10 11.819l-2.651 3.029a1.2 1.2 0 1 1-1.697-1.697l2.758-3.15-2.759-3.152a1.2 1.2 0 1 1 1.697-1.697L10 8.183l2.651-3.031a1.2 1.2 0 1 1 1.697 1.697l-2.758 3.152 2.758 3.15a1.2 1.2 0 0 1 0 1.698z"/></svg>
    </span>
  </div>
</template>
<script>
import { computed, watch, reactive } from '@vue/composition-api';

export default {
  name: 'AlertMessage',
  props: {
    emphasis: {
      type: String,
      default: () => ''
    },
    text: {
      type: String,
      default: () => ''
    },
    isError: {
      type: Boolean,
      default: () => false
    }
  },
  setup(props, { emit }) {
    const defaultDivClasses = 'border px-4 py-3 rounded relative mb-3';
    const errorDivClasses = `bg-red-100 border-red-400 text-red-700 ${defaultDivClasses}`;
    const successDivClasses = `bg-green-100 border-green-400 text-green-700 ${defaultDivClasses}`;

    const defaultSvgClasses = 'fill-current h-6 w-6';
    const errorSvgClasses = `text-red-500 ${defaultSvgClasses}`;
    const successSvgClasses = `text-green-500 ${defaultSvgClasses}`;

    const allText = computed(() => `${props.emphasis}${props.text}`);
    const state = reactive({
      allText,
      divClasses: computed(() => props.isError ? errorDivClasses : successDivClasses),
      svgClasses: computed(() => props.isError ? errorSvgClasses : successSvgClasses),
      shown: !!allText.value.length
    });

    watch(
      () => state.allText, 
      (newText, _prevText) => {
        state.shown = true;
      }
    );

    const onClose = () => {
      state.shown = false;
      emit('closed');
    };

    return {
      state,
      onClose
    };
  }
};
</script>
