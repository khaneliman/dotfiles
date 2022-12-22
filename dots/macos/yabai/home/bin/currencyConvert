cc() {
  wget -qO- "http://www.google.com/finance/converter?a=$1&from=$2&to=$3" |  sed '/res/!d;s/<[^>]*>//g';
}
