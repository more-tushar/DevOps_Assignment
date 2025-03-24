sum=0
count=0

while read num; do
  sum=$(echo "$sum + $num" | bc)
  count=$((count + 1))
done < numbers.txt

average=$(echo "scale=2; $sum / $count" | bc)
echo "Average: $average"
