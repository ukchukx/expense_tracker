import { displayAmount } from '@/features/budgetUtils';

export default function useAmountFormatter() {
  const amountFormatter = (amount) => displayAmount(amount);
  const koboAmountToNaira = (amount) => (amount / 100).toFixed(2);
  const formatKoboAmount = (amount) => amountFormatter(koboAmountToNaira(amount));

  return { amountFormatter, formatKoboAmount, koboAmountToNaira };
}
