<template>
  <!-- eslint-disable -->
  <input type="hidden" name="_csrf_token" :value="csrfToken">
</template>
<script>
import { onMounted, ref } from '@vue/composition-api';

export default {
  name: 'CsrfToken',
  setup() {
    const csrfToken = ref('');

    onMounted(() => {
      const meta = document.head.querySelector('meta[name="csrf-token"]');
      if (meta) csrfToken.value = meta.content;
    });

    return {
      csrfToken
    };
  }
};
</script>
