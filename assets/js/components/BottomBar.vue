<template>
  <!-- eslint-disable -->
  <div class="fixed bottom-0 inset-x-0 bg-white h-24 w-full">
    <div class="block w-full">
      <div class="container mx-auto">
        <div class="flex items-stretch">
          <div class="flex mx-auto">
            <a @click="selectMovies" href="#" :class="state.movieClasses">
              <svg class="h-6 w-6 fill-current block mx-auto" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill-rule="evenodd" d="M20,5V3.799C20,3.357,19.643,3,19.201,3h-18.4C0.358,3,0,3.357,
                0,3.799V5h2v2H0v2h2v2H0v2h2v2H0v1.199 C0,16.641,0.358,17,0.801,17h18.4C19.643,17,20,16.641,20,16.199V15h-2v-2h2v-2h-2V9h2V7h-2V5H20z M8,13V7l5,3L8,13z"/></svg>

              <span class="text-sm md:text-md">Movies</span>
            </a>
          </div>
          <div class="flex mx-auto">
            <a @click="selectBooks" href="#" :class="state.bookClasses">
              <svg class="h-6 w-6 fill-current block mx-auto" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M17,5.95v10.351c0,0.522-0.452,0.771-1,1.16c-0.44,0.313-1-0.075-1-0.587c0,0,0-9.905,0-10.114
                c0-0.211-0.074-0.412-0.314-0.535C14.446,6.102,6.948,2.16,6.948,2.16C6.827,2.115,6.299,1.782,5.595,2.144
                C4.926,2.488,4.562,2.862,4.469,3.038l8.18,4.482C12.866,7.634,13,7.81,13,8.036v10.802c0,0.23-0.142,0.476-0.369,0.585
                c-0.104,0.052-0.219,0.077-0.333,0.077c-0.135,0-0.271-0.033-0.386-0.104c-0.215-0.131-7.774-4.766-8.273-5.067
                c-0.24-0.144-0.521-0.439-0.527-0.658L3,3.385c0-0.198-0.023-0.547,0.289-1.032c0.697-1.084,3.129-2.317,4.36-1.678l8.999,4.555
                C16.865,5.342,17,5.566,17,5.95z" fill-rule="nonzero"/></svg>

              <span class="text-sm md:text-md">Books</span>
            </a>
          </div>
          <div class="flex mx-auto">
            <a @click="selectAccounts" href="#" :class="state.accountClasses">
              <svg class="h-6 w-6 fill-current block mx-auto" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M7.725,2.146c-1.016,0.756-1.289,1.953-1.239,2.59C6.55,5.515,6.708,6.529,6.708,6.529
                s-0.313,0.17-0.313,0.854C6.504,9.1,7.078,8.359,7.196,9.112c0.284,1.814,0.933,1.491,0.933,2.481c0,1.649-0.68,2.42-2.803,3.334
                C3.196,15.845,1,17,1,19v1h18v-1c0-2-2.197-3.155-4.328-4.072c-2.123-0.914-2.801-1.684-2.801-3.334c0-0.99,0.647-0.667,0.932-2.481
                c0.119-0.753,0.692-0.012,0.803-1.729c0-0.684-0.314-0.854-0.314-0.854s0.158-1.014,0.221-1.793c0.065-0.817-0.398-2.561-2.3-3.096
                c-0.333-0.34-0.558-0.881,0.466-1.424C9.439,0.112,8.918,1.284,7.725,2.146z" fill-rule="nonzero"/></svg>

              <span class="text-sm md:text-md">Account</span>
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { reactive, computed } from '@vue/composition-api';
import eventBus from '@/eventBus';

export default {
  name: 'BottomBar',
  props: {
    selectedTab: {
      type: String,
      default: () => 'movies'
    }
  },
  setup(props) {
    const commonClasses = 'no-underline inline-block text-center py-4 border-b';
    let defaultClasses = 'opacity-50 text-gray-600 md:opacity-100 border-transparent hover:opacity-100';
    defaultClasses = `md:hover:border-gray-600 ${defaultClasses} ${commonClasses}`;
    const activeClasses = `text-blue-600 border-blue-600 ${commonClasses}`;

    const moviesSelected = computed(() => props.selectedTab === 'movies');
    const booksSelected = computed(() => props.selectedTab === 'books');
    const accountSelected = computed(() => props.selectedTab === 'account');

    const selectMovies = () => eventBus.$emit('movies-selected');
    const selectBooks = () => eventBus.$emit('books-selected');
    const selectAccounts = () => eventBus.$emit('account-selected');

    const state = reactive({
      movieClasses: computed(() => moviesSelected.value ? activeClasses : defaultClasses),
      bookClasses: computed(() => booksSelected.value ? activeClasses : defaultClasses),
      accountClasses: computed(() => accountSelected.value ? activeClasses : defaultClasses)
    });

    return {
      selectMovies,
      selectBooks,
      selectAccounts,
      state
    };
  }
};
</script>
