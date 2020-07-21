const minLength = (min) => (input) => input.length < min ? `Must have at least ${min} characters` : null;

const isEmail = () => (input) => /\S+@\S+\.\S+/.test(input) ? null : 'Must be a valid email address';

export { 
  minLength, 
  isEmail
};
