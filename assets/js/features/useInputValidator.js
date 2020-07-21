import { ref, watch } from '@vue/composition-api';

export default function (startVal, validators, onValidate) { // eslint-disable-line func-names
  const input = ref(startVal);
  const errors = ref([]);

  watch(input, (value) => {
    errors.value = validators
      .map((validator) => validator(value))
      .filter((x) => !!x);
    
    onValidate(value);
  });

  return {
    input,
    errors
  };
}
