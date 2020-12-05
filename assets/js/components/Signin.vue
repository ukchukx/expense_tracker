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
          :showErrors="false"
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
          @enter-pressed="submitForm"
          :showErrors="false"
          class="mb-6" 
          label="Password" 
          placeholder="Password" 
          type="password"
          name="password"
          extraInputClasses="w-full" />
        
        <div class="flex items-center justify-between">
          <button 
            :disabled="hasErrors"
            @click="submitForm"
            class="bg-teal-500 hover:bg-teal-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline" 
            type="button">
            Sign In
          </button>
          <a class="inline-block align-baseline font-bold text-sm text-teal-500 hover:text-teal-800" href="#">
            Forgot Password?
          </a>
        </div>
        <a class="inline-block align-baseline font-bold text-sm text-teal-500" href="/signup">
          Don't have an account? Sign Up
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
  name: 'Signin',
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
    const emailValidators = [isEmail()];
    const passwordValidators = [minLength(8)];
    const state = reactive({
      email: '', 
      password: '',
      emailErrors: [],
      passwordErrors: []
    });
    const hasErrors = computed(() => {
      const { email, password, passwordErrors, emailErrors } = state;
      const errors = emailErrors.concat(passwordErrors).length !== 0;

      return email.trim().length === 0 || password.trim().length === 0 || errors;
    });

    const onEmailErrors = (errors) => {
      state.emailErrors = errors;
    };
    const onPasswordErrors = (errors) => {
      state.passwordErrors = errors;
    };

    const submitForm = () => { 
      if (!hasErrors.value) refs.form.submit();
    };

    return {
      emailValidators,
      passwordValidators,
      onEmailErrors,
      onPasswordErrors,
      state,
      hasErrors,
      submitForm
    };
  }
};
</script>
