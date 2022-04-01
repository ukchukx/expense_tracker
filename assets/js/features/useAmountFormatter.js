import { displayAmount } from '@/features/budgetUtils';

export default function useAmountFormatter() {
  const amountFormatter = (amount, currency = 'NGN') => displayAmount(amount, currency);
  const koboAmountToNaira = (amount) => (amount / 100).toFixed(2);
  const formatKoboAmount = (amount, currency = 'NGN') => amountFormatter(koboAmountToNaira(amount), currency);
  const currencySymbol = (currency = 'NGN') => {
    const str = displayAmount(1, currency).match(/\D+/g);

    return currency === 'SEK' ? str[1] : str[0];
  }

  return { amountFormatter, formatKoboAmount, koboAmountToNaira, currencySymbol };
}
