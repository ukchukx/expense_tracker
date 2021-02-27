<template>
  <!-- eslint-disable -->
  <div class="bg-green-500">
    <div class="container mx-auto px-4">
      <div class="flex items-center md:justify-between py-4">
        <div class="w-1/4 md:hidden">
        </div>
        <div class="w-1/2 md:w-auto text-center text-white text-2xl font-medium">
          expense tracker
        </div>
        <div class="w-1/4 md:w-auto md:flex text-right">
          <div>
            <img class="inline-block h-8 w-8 rounded-full" src="https://via.placeholder.com/32" alt="">
          </div>
          <div class="hidden md:block md:flex md:items-center ml-2">
            <span class="text-white text-sm mr-1">{{ username }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: 'TopBar',
  props: {
    username: {
      type: String,
      required: true
    }
  }
};
</script>
