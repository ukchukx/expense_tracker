<template>
  <!-- eslint-disable -->
  <div class="max-w-sm w-full">
    <AlertMessage :text="errorMessage" isError />
    <div class="w-full">
      <form 
        :action="formPath" 
        method="POST" 
        ref="form" 
        class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4">
        <CsrfToken />

        <Input 
          v-model="state.email"
          :validators="emailValidators"
          @errors="onEmailErrors"
          class="mb-4" 
          label="Email" 
          placeholder="Email" 
          type="text" 
          name="email"
          extraInputClasses="w-full" />
        
        <Input 
          v-model="state.password"
          :validators="passwordValidators"
          @errors="onPasswordErrors"
          class="mb-4" 
          label="Password" 
          placeholder="Password" 
          type="password"
          name="password"
          extraInputClasses="w-full" />
        
        <Input 
          v-model="state.passwordConfirmation"
          class="mb-2" 
          label="Password confirmation" 
          placeholder="Password confirmation" 
          type="password"
          extraInputClasses="w-full" />
        <p v-show="passwordMismatch" class="text-red-500 text-xs italic">Password values do not match</p>
        
        <div class="flex items-center justify-between mt-4">
          <button 
            :disabled="hasErrors"
            @click="submitForm"
            class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline" 
            type="button">
            Sign Up
          </button>
        </div>
        <a class="inline-block align-baseline font-bold text-sm text-green-500" href="/signin">
          Have an account? Sign In
        </a>
      </form>
      <p class="text-center text-white text-xs">
        &copy;2020 Expense Tracker
      </p>
    </div>
  </div>
</template>
<script>
import { computed, reactive } from '@vue/composition-api';
import Input from '@/components/Input';
import AlertMessage from '@/components/AlertMessage';
import CsrfToken from '@/components/CsrfToken';
import { isEmail, minLength } from '@/validators';

export default {
  name: 'Signup',
  components: {
    AlertMessage,
    CsrfToken,
    Input
  },
  props: {
    formPath: {
      type: String,
      required: true
    },
    errorMessage: {
      type: String,
      default: () => ''
    }
  },
  setup(props, { refs }) {
    const state = reactive({
      email: '', 
      password: '',
      passwordConfirmation: '',
      emailErrors: [],
      passwordErrors: [],
      passwordConfirmationErrors: []
    });
    const passwordMismatch = computed(() => state.password !== state.passwordConfirmation);
    const hasErrors = computed(() => {
      const { email, password, passwordErrors, emailErrors } = state;
      const errors = emailErrors.concat(passwordErrors).length !== 0;

      return email.trim().length === 0 || password.trim().length === 0 || errors || passwordMismatch.value;
    });

    const emailValidators = [isEmail()];
    const passwordValidators = [minLength(8)];

    const onEmailErrors = (errors) => {
      state.emailErrors = errors;
    };
    const onPasswordErrors = (errors) => {
      state.passwordErrors = errors;
    };

    const submitForm = () => { 
      refs.form.submit();
    };

    return {
      emailValidators,
      passwordValidators,
      onEmailErrors,
      onPasswordErrors,
      state,
      hasErrors,
      submitForm,
      passwordMismatch
    };
  }
};
</script>
