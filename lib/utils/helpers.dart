
int calculateMonthCount(int startYear, startMonth, currentYear, currentMonth)
{
  int monthCount = (currentYear - startYear) * 12 + currentMonth - startYear + 1;
  return monthCount; 
}