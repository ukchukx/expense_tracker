const monthName = (month) => [
  'January', 
  'February', 
  'March', 
  'April', 
  'May', 
  'June', 
  'July', 
  'August', 
  'September', 
  'October', 
  'November', 
  'December'][month];

const moneyFormatter = (currency) => {
  let locale = 'en-NG';
  if (currency === 'SEK') locale = 'en-SE';
  if (currency === 'USD') locale = 'en-US';
  if (['GBP', 'EUR'].includes(currency)) locale = 'en-UK';

  return new Intl.NumberFormat(locale, { style: 'currency', currency });
};

const displayAmount = (amount, currency) => moneyFormatter(currency).format(amount);

const totalBudgetAmount = (budget) => budget.line_items.reduce((sum, { amount }) => sum + +amount, 0);

const totalBudgetExpense = (budget) => budget.line_items.reduce((sum, { expensed }) => sum + +expensed, 0);

const getDateString = (date) => {
  const mm = date.getMonth() + 1;
  const dd = date.getDate();

  return `${date.getFullYear()}-${mm >= 10 ? mm : `0${mm}`}-${dd >= 10 ? dd : `0${dd}`}`;
};

const currentBudgetName = () => {
  const today = new Date();
  return `${monthName(today.getMonth())}, ${today.getFullYear()}`;
};

const currentBudgetStartDate = () => getDateString(new Date());

const currentBudgetEndDate = () => {
  const today = new Date();
  const lastDayOfCurrentMonth = new Date(today.getFullYear(), today.getMonth() + 1, 0);

  return getDateString(lastDayOfCurrentMonth);
};

export { 
  getDateString,
  currentBudgetName, 
  currentBudgetStartDate, 
  currentBudgetEndDate, 
  displayAmount,
  totalBudgetAmount,
  totalBudgetExpense
};
