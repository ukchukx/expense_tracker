import { displayAmount } from '@/features/budgetUtils';

export default function() {
  const amountFormatter = (amount) => displayAmount(amount);
  const formatKoboAmount = (koboAmount) => amountFormatter((koboAmount / 100).toFixed(2));

  return { amountFormatter, formatKoboAmount };
};