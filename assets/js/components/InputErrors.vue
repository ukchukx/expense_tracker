<template>
  <!-- eslint-disable -->
  <div>
    <p v-for="(e, i) in errors" :key="i" class="text-red-500 text-xs italic">{{ e }}</p>
  </div>
</template>
<script>
export default {
  name: 'InputErrors',
  props: {
    errors: {
      type: Array,
      default: () => []
    }
  }
};
</script>
