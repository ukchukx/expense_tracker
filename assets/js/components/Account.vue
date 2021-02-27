<template>
  <!-- eslint-disable -->
  <Page :user="user" selected-tab="account">
    <div class="text-center px-6 py-4">
      <div class="py-8">
        <h2 class="py-8">{{ user.email }}</h2>
        <div>
          <a 
            href="/signout"
            class="bg-transparent text-green-700 border border-green-700 rounded px-6 py-2">
            Sign out
          </a>
        </div>
      </div>
    </div>
  </Page>
</template>
<script>
import Page from '@/components/Page';

export default {
  name: 'Account',
  components: {
    Page
  },
  props: {
    user: {
      type: Object,
      required: true
    }
  }
};
</script>
