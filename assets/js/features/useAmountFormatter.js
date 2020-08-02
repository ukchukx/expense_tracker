import { displayAmount } from '@/features/budgetUtils';

export default function() {
  const amountFormatter = (amount) => displayAmount(amount);

  return { amountFormatter };
};