<template>
  <!-- eslint-disable -->
  <div class="font-sans bg-gray-lighter flex flex-col min-h-screen w-full">
    <TopBar :username="username" />

    <div class="h-screen flex-grow container mx-auto pb-8">
       <div class="flex flex-wrap pb-24">
        <div class="w-full flex flex-col">
          <div class="flex-grow flex flex-col bg-white overflow-hidden">
            <slot />
          </div>
        </div>
       </div>
      <BottomBar :selectedTab="state.selectedTab" />
    </div>
  </div>
</template>
<script>
import TopBar from '@/components/TopBar';
import BottomBar from '@/components/BottomBar';
import eventBus from '@/eventBus';
import { reactive } from '@vue/composition-api';

export default {
  name: 'Page',
  components: {
    BottomBar,
    TopBar
  },
  props: {
    username: {
      type: String,
      default: () => 'Guest'
    }
  },
  setup() {
    const state = reactive({
      selectedTab: 'movies'
    });

    eventBus.$on('movies-selected', () => {
      state.selectedTab = 'movies';
    });
    eventBus.$on('books-selected', () => {
      state.selectedTab = 'books';
    });
    eventBus.$on('account-selected', () => {
      state.selectedTab = 'account';
    });

    return {
      state
    };
  }
};
</script>
