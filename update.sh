#!/bin/bash
# Usage: ./update.sh <weixin_pay_url> <product_name>
# Example: ./update.sh "weixin://wxpay/bizpayurl?pr=abc123" "生椰拿铁冰"

cd "$(dirname "$0")"

PAY_URL="$1"
PRODUCT_NAME="$2"

if [ -z "$PAY_URL" ]; then
  echo "Usage: ./update.sh <weixin_pay_url> [product_name]"
  echo "Example: ./update.sh \"weixin://wxpay/bizpayurl?pr=abc123\" \"生椰拿铁冰\""
  exit 1
fi

[ -z "$PRODUCT_NAME" ] && PRODUCT_NAME="瑞幸咖啡"

# Escape for sed
PAY_URL_ESC=$(echo "$PAY_URL" | sed 's/[\/&]/\\&/g')
PRODUCT_ESC=$(echo "$PRODUCT_NAME" | sed 's/[\/&]/\\&/g')

# Update all 3 occurrences of the payment URL (meta refresh, href, window.location.href)
sed -i '' "s|weixin://wxpay/bizpayurl?pr=[^\"' ]*|$PAY_URL|g" index.html
# Update product name (first <p> after the card div)
sed -i '' "s|>.*冰 不另外加糖</p>|>$PRODUCT_ESC</p>|" index.html

git commit -a -m "Update: $PRODUCT_NAME"
git push

echo "✅ Updated! https://doooos.github.io/luckin-pay-redirect/"
