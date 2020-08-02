<template>
  <!-- eslint-disable -->
  <div class="font-sans bg-gray-lighter flex flex-col min-h-screen w-full">
    <TopBar :username="user.email" />

    <div class="h-screen flex-grow container mx-auto pb-8">
       <div class="flex flex-wrap pb-24">
        <div class="w-full flex flex-col">
          <div class="flex-grow flex flex-col bg-white overflow-hidden">
            <slot />
          </div>
        </div>
       </div>
      <BottomBar :selectedTab="selectedTab" />
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
    user: {
      type: Object,
      default: () => ({})
    },
    selectedTab: {
      type: String,
      default: () => ''
    }
  }
};
</script>
